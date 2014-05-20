require_relative 'chess_piece'

class King < ChessPiece

  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    possible_moves.concat( board.find_king_spaces( self ) )

    possible_moves
  end
  
  def check?( possible_enemy_moves_array )
    row = self.position.file_position_converter
    column = self.position.rank_position_converter
    
    possible_enemy_moves_array.include?( [column, row] )
  end
end