require_relative 'chess_piece'

class King < ChessPiece
  
  attr_reader :checkmate, :board_marker
  
  def initialize( file, rank, team, board )
    super
    @checkmate = false
    @board_marker = determine_board_marker
  end

  def determine_possible_moves
    clear_moves!
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

  def determine_board_marker
    team == :white ? "♔" : "♚"
  end
end