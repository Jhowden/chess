require_relative 'chess_piece'

class Knight < ChessPiece
  
  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    
    possible_moves.concat( board.find_knight_spaces( self ) )
    
    possible_moves
  end

end