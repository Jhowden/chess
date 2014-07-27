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
end