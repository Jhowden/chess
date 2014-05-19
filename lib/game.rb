class Game

  attr_reader :player1, :player2, :board

  def initialize( board )
    @board = board
  end
  
  def get_player_teams
    puts "Please choose your team player 1..."
    player1_team = user_input
    @player1 = set_player_team( player1_team )
    puts "Please choose your team player 2..."
    player2_team = user_input
    @player2 = set_player_team( player2_team )
  end

  def get_player_move
    puts "Please select a piece you would like to move and its new position (ex: b3 b6):"
    user_input
  end

  def player_and_piece_same_team?( piece_position, player )
    piece = find_piece_on_board( piece_position )
    piece.team == player.team
  end

  def check_move( piece_position, target_location )
    piece = find_piece_on_board( piece_position )
    possible_moves = piece.determine_possible_moves
    possible_moves.include?( target_location )
  end

  def update_position( piece_position, file, rank )
    piece = find_piece_on_board( piece_position )
    piece.update_piece_position( file, rank )
  end

  def player_turn_commands( player )
    player_input = get_player_move.gsub( /\s+/, "" )
    piece_position = convert_to_position( player_input[0], player_input[1] )
    target_file, target_rank = convert_to_file_and_rank( player_input[2], player_input[3] )
    if player_and_piece_same_team?( piece_position, player )
      if check_move( piece_position, [target_file , target_rank] )
        update_position( piece_position, target_file, target_rank )
      else
        puts "That is not a valid move that piece. Please pick again."
        player_turn_command( player )
      end
    else
      puts "That piece is not on your team. Please pick again."
      player_turn_command( player )
    end
  end

  def user_input
    print "> "
    gets.chomp
  end

  private

  def set_player_team( team )
    Player.new( team.to_sym )
  end

  def find_piece_on_board( piece_position )
    board.find_piece( piece_position )
  end

  def convert_to_position( file, rank )
    Position.new( file, rank.to_i )
  end

  def convert_to_file_and_rank( file, rank )
    return file, rank.to_i
  end
end