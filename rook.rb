require_relative 'chess_piece'

class Rook < ChessPiece
  
  attr_reader :possible_moves

  def initialize( name, file, rank, team, board )
    super
    @possible_moves = []
  end
  
  def determine_possible_moves
    possible_moves.clear
    
    possible_moves.concat( board.find_horizontal_spaces( self ) )
    possible_moves.concat( board.find_vertical_spaces( self ) )
    
    possible_moves
  end
end