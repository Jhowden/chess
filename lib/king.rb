require_relative 'chess_piece'

class King < ChessPiece
  
  attr_reader :checkmate
  
  def initialize( marker, file, rank, team, board )
    super
    @checkmate = false
  end

  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    possible_moves.concat( board.find_king_spaces( self ) )

    possible_moves
  end
  
  def check?( possible_enemy_moves_array )
    file = position.file
    rank = position.rank
    
    possible_enemy_moves_array.include?( [file, rank] )
  end
  
  def checkmated
    @checkmate = true
  end
  
  def checkmated?
    checkmate
  end
end