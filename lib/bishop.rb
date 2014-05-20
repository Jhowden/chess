require_relative 'chess_piece'

class Bishop < ChessPiece
  
  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    
    possible_moves.concat( board.find_diagonal_spaces( self ) )
    
    possible_moves
  end
end