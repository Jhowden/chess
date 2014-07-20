File.expand_path( File.join( File.dirname( __FILE__ ), 'board_setup_helper' ) )
File.expand_path( File.join( File.dirname( __FILE__ ), 'board_piece_locator' ) )

class Game
  attr_reader :player1, :player2, :board, :board_view, :chess_board, :user_commands, :checkmate, :castle

  include BoardSetupHelper
  include BoardPieceLocator

  def initialize( board, user_commands = UserCommands.new, board_view = BoardView.new )
    @board = board
    @board_view = board_view
    @user_commands = user_commands
    @checkmate = Checkmate.new( self )
    @castle = Castle.new( self )
  end
  
  def play!
    get_player_teams
    until finished?
      player_sequence( "Player 1: ", player1, player2 )
      break if finished?
      player_sequence( "Player 2: ", player2, player1 )
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
      if player_input =~ UserCommands::VALID_QUEENSIDE_CASTLING_INPUT
        castle.castle_queenside( player.king_piece, Castle::TEAM_COLOR_CASTLE_RANK_MAP[player.team], 
                                  player, enemy_player )
      # elsif player_input =~ UserCommands::VALID_KINGSIDE_CASTLING_INPUT
      else
        move_piece_sequence( player, enemy_player, player_input )
      end
    end
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
    check_king_for_check( player, enemy_player_moves )
  end

  def restore_piece_to_original_position( piece, piece_original_position, new_position )
    update_the_board!( piece, piece_original_position.file, piece_original_position.rank, new_position )
  end

  def increase_piece_move_counter( piece )
    piece.increase_move_counter!
  end
  
  private
  
  def convert_to_file_and_rank( file, rank )
    return file, rank.to_i
  end
  
  def display_invalid_message( message, player, enemy_player )
    puts message
    start_player_move( player, enemy_player )
  end

  def clear_screen!
    print "\e[H\e[2J"
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
  
  def convert_to_position( file, rank )
    Position.new( file, rank.to_i )
  end
  
  def check_king_for_check( player, enemy_player_moves)
    player.king_piece.check? enemy_player_moves
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
  
  def finished?
    [player1, player2].any? { |player| player.checkmate? }
  end
  
  def check_for_checkmate( player, possible_moves_list )
    if possible_moves_list.empty?
      player.checkmate!
    end
  end

  def player_sequence( message, player, enemy_player )
    display_board
    puts message
    start_player_move( player, enemy_player )
    clear_screen!
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

  def move_piece( piece, player, enemy_player, target_file, target_rank, piece_position )
    if player_and_piece_same_team?( piece, player )
      if check_move?( piece, [target_file , target_rank] )
        piece_original_position = piece_position.dup
        enemy_piece = self.find_piece_on_board( convert_to_position( target_file, target_rank ) )
        update_the_board!( piece, target_file, target_rank, piece_position )
        if player_in_check?( player, enemy_player )
          restore_board_to_original( piece, piece_original_position, 
                                      convert_to_position( target_file, target_rank ), enemy_piece, player, enemy_player )
        end
        increase_piece_move_counter( piece )
      else
        display_invalid_message( "That is not a valid move for that piece.", player, enemy_player )
      end
    else
      display_invalid_message( "That piece is not on your team.", player, enemy_player )
    end
  end

  def restore_board_to_original( piece, piece_original_position, piece_position, enemy_piece, player, enemy_player )
    restore_piece_to_original_position( piece, piece_original_position, piece_position )
    restore_captured_piece_on_board( enemy_piece ) if enemy_piece.respond_to? :determine_possible_moves
    puts "That is an invalid move as it puts your king in check. Select another move..."
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

  def get_player_teams
    puts "Please choose your team player 1 (white or black):"
    player1_team_color = user_commands.user_team_input
    @player1 = set_player_team( player1_team_color.to_sym )
    set_up_players_half_of_board( player1_team_color.to_sym, player1 )
    player2_team_color = player1.team == :white ? "black" : "white"
    puts "Player 2's team has been set to #{player2_team_color}"
    @player2 = set_player_team( player2_team_color.to_sym )
    set_up_players_half_of_board( player2_team_color.to_sym, player2 )
  end

  def winner
    winner = [player1, player2].reject { |player| player.checkmate? }
    puts "#{winner.first.team.capitalize} team is the winner!"
  end
end