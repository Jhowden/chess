require_relative 'chess_piece'

class King < ChessPiece

  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    possible_moves.concat( board.find_king_spaces( self ) )

    possible_moves
  end
  
  def check?( possible_enemy_moves_array ) # have an array of pieces for each team and iterate through to find there possible moves
    file = position.file
    rank = position.rank
    
    possible_enemy_moves_array.include?( [file, rank] )
  end
end