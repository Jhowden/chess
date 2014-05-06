require_relative 'chess_piece'

class King < ChessPiece

  def initialize( name, file, rank, team, board )
    super
  end

  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    possible_moves.concat( board.find_king_spaces( self ) )

    possible_moves
  end
end