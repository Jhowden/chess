require_relative 'chess_piece'

class Rook < ChessPiece
  
  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    
    possible_moves.concat( board.find_horizontal_spaces( self ) )
    possible_moves.concat( board.find_vertical_spaces( self ) )
    
    possible_moves
  end
end