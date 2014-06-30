File.expand_path( File.join( File.dirname( __FILE__ ), 'board_setup_helper' ) )
File.expand_path( File.join( File.dirname( __FILE__ ), 'board_piece_locator' ) )

class Game
  attr_reader :player1, :player2, :board, :board_view, :chess_board, :user_commands, :checkmate

  include BoardSetupHelper
  include BoardPieceLocator

  def initialize( board, user_commands = UserCommands.new, board_view = BoardView.new )
    @board = board
    @board_view = board_view
    @user_commands = user_commands
    @checkmate = Checkmate.new( self )
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

  def get_player_move
    puts "Please select a piece you would like to move and its new position (ex: b3 b6):"
    user_commands.user_move_input
  end

  def player_and_piece_same_team?( piece, player )
    piece.team == player.team
  end

  def check_move?( piece, target_location ) # pass in option parameter for legal check moves and use that if passed in, otherwise use #determine_possible_moves
    possible_moves = piece.determine_possible_moves
    possible_moves.include?( target_location )
  end

  def update_position( piece, file, rank )
    piece.update_piece_position( file, rank )
  end
  
  def update_the_board!( piece, target_file, target_rank, piece_position )
    update_position( piece, target_file, target_rank )
    update_piece_on_board( piece )
    remove_piece_old_position( piece_position )
  end
  
  def move_piece( piece, player, enemy_player, target_file, target_rank, piece_position )
    if player_and_piece_same_team?( piece, player )
      if check_move?( piece, [target_file , target_rank] )
        update_the_board!( piece, target_file, target_rank, piece_position )
      else
        display_invalid_message( "That is not a valid move for that piece.", player, enemy_player )
      end
    else
      display_invalid_message( "That piece is not on your team.", player, enemy_player )
    end
  end

  def start_player_move( player, enemy_player )
    if player_in_check?( player, enemy_player )
      puts "Your king is in check!"
      player_input = get_player_move.gsub( /\s+/, "" )
      piece_position = convert_to_position( player_input[0], player_input[1] )
      piece = find_piece_on_board( piece_position )
      target_file, target_rank = convert_to_file_and_rank( player_input[2], player_input[3] )
      # pass in the array returned from the checkmate call
      move_piece( piece, player, enemy_player, target_file, target_rank, piece_position )
    else
      move_without_checkmate( player, enemy_player )
    end
  end

  def move_without_checkmate( player, enemy_player )
    player_input = get_player_move.gsub( /\s+/, "" )
    piece_position = convert_to_position( player_input[0], player_input[1] )
    piece = find_piece_on_board( piece_position )
    target_file, target_rank = convert_to_file_and_rank( player_input[2], player_input[3] )
    move_piece( piece, player, enemy_player, target_file, target_rank, piece_position )
  end
  
  def display_board
    board_view.display_board( board )
  end
  
  def player_in_check?( player, enemy_player ) # why not also check to see if the array includes the player's king's position
    enemy_player_moves = enemy_player.team_pieces.map { |piece|
      next if piece.captured? 
      piece.determine_possible_moves
    }.flatten( 1 ).compact
    check_king_for_check( player, enemy_player_moves )
  end
  
  def check_king_for_check( player, enemy_player_moves)
    player.king_piece.check? enemy_player_moves
  end
  
  def play!
    get_player_teams
    while true
      player_sequence( "Player 1: ", player1, player2 )
      player_sequence( "Player 2: ", player2, player1 )
    end
  end

  def player_sequence( message, player, enemy_player )
    display_board
    puts message
    start_player_move( player, enemy_player )
    clear_screen!
  end
  
  def convert_to_position( file, rank )
    Position.new( file, rank.to_i )
  end
  
  def replace_board new_board
    @board = new_board
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
end