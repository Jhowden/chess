class Player

  attr_reader :team, :team_pieces, :king_piece, :checkmate

  def initialize( team )
    @team = team
    @checkmate = false
  end

  def set_team_pieces( pieces )
    @team_pieces = []
    team_pieces.concat pieces
  end

  def find_king_piece
    @king_piece = team_pieces.detect { |piece| piece.is_a? King }
  end

  def checkmate!
    @checkmate = true
  end

  def checkmate?
    checkmate
  end
end