$LOAD_PATH.unshift( File.expand_path(File.dirname( __FILE__ ) ) ) unless $LOAD_PATH.include?( File.expand_path(File.dirname( __FILE__ ) ) )
require "board_setup_commands"
require "board_piece_locator"
require "finished"
require "en_passant_moves"

class Game
  attr_reader :player1, :player2, :board, :board_view, :chess_board, :user_commands, 
              :checkmate, :castle, :en_passant

  include BoardPieceLocator
  include BoardSetupCommands
  include EnPassantMoves
  include Finished

  def initialize( board, user_commands = UserCommands.new, board_view = BoardView.new )
    @board = board
    @board_view = board_view
    @user_commands = user_commands
    @checkmate = Checkmate.new( self )
    @castle = Castle.new( self )
    @en_passant = EnPassant.new( self )
  end
  
  def play!
    get_player_teams
    until finished?
      player_sequence( player1, player2 )
      break if finished?
      player_sequence( player2, player1 )
    end
    display_board
    winner
  end

  def start_player_move( player, enemy_player )
    if player_in_check?( player, enemy_player )
      escape_check_moves = checkmate.find_checkmate_escape_moves( player, enemy_player )
      check_for_checkmate( player, escape_check_moves )
      return if player.checkmate?
      king_in_check_sequence( escape_check_moves, player, enemy_player )
    else
      player_input = get_player_move.gsub( /\s+/, "" )
      select_correct_move_sequence( player_input, player, enemy_player )
    end
    update_enemy_pawn_status_for_en_passant( enemy_player.team_pieces, enemy_player.team )
  end
  
  def update_the_board!( piece, target_file, target_rank, piece_position )
    update_position( piece, target_file, target_rank )
    update_piece_on_board( piece )
    remove_piece_old_position( piece_position )
  end
  
  def player_in_check?( player, enemy_player )
    enemy_player_moves = enemy_player.team_pieces.map { |piece|
      next if piece.captured? 
      piece.determine_possible_moves
    }.flatten( 1 ).compact
    check_king_for_check( player.king_piece, enemy_player_moves )
  end

  def restore_piece_to_original_position( piece, piece_original_position, new_position )
    update_the_board!( piece, piece_original_position.file, piece_original_position.rank, new_position )
  end

  def increase_piece_move_counter( piece )
    piece.increase_move_counter!
  end
  
  def convert_to_position( file, rank )
    Position.new( file, rank.to_i )
  end
  
  private
  
  def convert_to_file_and_rank( file, rank )
    return file, rank.to_i
  end
  
  def display_invalid_message( message, player, enemy_player )
    puts message
    start_player_move( player, enemy_player )
  end
  
  def get_player_move
    puts "Please select a piece you would like to move and its new position (ex: b3 b6):"
    user_commands.user_move_input
  end
  
  def player_and_piece_same_team?( piece, player )
    piece.team == player.team
  end
  
  def update_position( piece, file, rank )
    piece.update_piece_position( file, rank )
  end
  
  def check_king_for_check( king, enemy_player_moves)
    king.check? enemy_player_moves
  end
  
  def display_board
    board_view.display_board( board )
  end
  
  def move_piece_sequence( player, enemy_player, player_input )
    piece_position = convert_to_position( player_input[0], player_input[1] )
    piece = find_piece_on_board( piece_position )
    target_file, target_rank = convert_to_file_and_rank( player_input[2], player_input[3] )
    move_piece( piece, player, enemy_player, target_file, target_rank, piece_position )
  end
  
  def check_for_checkmate( player, possible_moves_list )
    player.checkmate! if possible_moves_list.empty?
  end

  def player_sequence( player, enemy_player )
    display_board
    puts "#{player.team.capitalize} team's turn: "
    start_player_move( player, enemy_player )
    ScreenClear.clear_screen!
  end
  
  def king_in_check_sequence( possible_moves_list, player, enemy_player )
    puts "Your king is in check!"
    player_input = get_player_move.gsub( /\s+/, "" )
    if possible_moves_list.include? player_input
      move_piece_sequence( player, enemy_player, player_input )
    else
      puts "Your king is still in check! Please select a valid move."
      start_player_move( player, enemy_player )
    end
  end
  
  def capture_the_piece( piece )
    piece.captured!
  end
  
  def check_adjacent_space( rank, counter )
    rank.to_i + counter
  end

  def move_piece( piece, player, enemy_player, target_file, target_rank, piece_position )
    if player_and_piece_same_team?( piece, player )
      if check_move?( piece, [target_file , target_rank] )
        perform_move( piece, player, enemy_player, target_file, target_rank, piece_position )
      else
        display_invalid_message( "That is not a valid move for that piece.", player, enemy_player )
      end
    else
      display_invalid_message( "That piece is not on your team.", player, enemy_player )
    end
  end
  
  def perform_move( piece, player, enemy_player, target_file, target_rank, piece_position )
    piece_original_position = piece_position.dup
    enemy_piece = find_piece_on_board( convert_to_position( target_file, target_rank ) )
    update_the_board!( piece, target_file, target_rank, piece_position )
    check_to_see_if_player_move_put_own_king_in_check( player, enemy_player, piece, piece_original_position, target_file, target_rank, enemy_piece )
    increase_piece_move_counter( piece )
  end
  
  def check_to_see_if_player_move_put_own_king_in_check( player, enemy_player, piece, piece_original_position, target_file, target_rank, enemy_piece )
    if player_in_check?( player, enemy_player )
      restore_board_to_original( piece, piece_original_position, 
                                  convert_to_position( target_file, target_rank ), enemy_piece, player, enemy_player )
    end
  end

  def castle_move_sequence( player, enemy_player, player_input )
    if player_input =~ UserCommands::VALID_QUEENSIDE_CASTLING_INPUT
        castle.castle_queenside( player.king_piece, Castle::TEAM_COLOR_CASTLE_RANK_MAP[player.team], 
                                  player, enemy_player )
    else 
        castle.castle_kingside( player.king_piece, Castle::TEAM_COLOR_CASTLE_RANK_MAP[player.team], 
                                  player, enemy_player )
    end
  end

  def restore_board_to_original( piece, piece_original_position, piece_position, enemy_piece, player, enemy_player )
    restore_piece_to_original_position( piece, piece_original_position, piece_position )
    restore_captured_piece_on_board( enemy_piece ) if enemy_piece.respond_to? :determine_possible_moves
    puts "That is an invalid move as it puts your king in check. Select another move."
    start_player_move( player, enemy_player )
  end

  def restore_captured_piece_on_board( enemy_piece )
    board.update_board enemy_piece
    enemy_piece.captured!
  end

  def check_move?( piece, target_location )
    possible_moves = piece.determine_possible_moves
    possible_moves.include?( target_location )
  end
  
  def select_correct_move_sequence( player_input, player, enemy_player )
    if UserCommands::VALID_CASTLING_EXPRESSION.any? { |expression| player_input =~ expression }
      castle_move_sequence( player, enemy_player, player_input )
    elsif player_input =~ UserCommands::VALID_EN_PASSANT_EXPRESSION
      en_passant_move_sequence( player, enemy_player, player_input )
    else
      move_piece_sequence( player, enemy_player, player_input )
    end
  end
end