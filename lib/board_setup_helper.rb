module BoardSetupHelper

  def set_up_players_half_of_board( team_color, player )
    set_players_team_pieces( player, create_team( team_color ) )
    place_pieces_on_board( player )
  end

  def set_players_team_pieces( player, pieces )
    player.set_team_pieces( pieces )
    player.find_king_piece
  end

  def place_pieces_on_board( player )
    board.place_pieces_on_board( player )
  end

  def create_team( team_color )
    team = PiecesFactory.new( board, team_color, en_passant )
    team.build
    team.pieces
  end

  def set_player_team( team_color )
    Player.new( team_color )
  end
  
  def get_player_teams
    puts "Please choose your team player 1 (white or black):"
    player1_team_color = user_commands.user_team_input
    @player1 = set_player_team( player1_team_color.to_sym )
    set_up_players_half_of_board( player1_team_color.to_sym, player1 )
    player2_team_color = determine_second_player_color
    puts "Player 2's team has been set to #{player2_team_color}"
    @player2 = set_player_team( player2_team_color.to_sym )
    set_up_players_half_of_board( player2_team_color.to_sym, player2 )
  end
  
  def determine_second_player_color
    player1.team == :white ? "black" : "white"
  end
end