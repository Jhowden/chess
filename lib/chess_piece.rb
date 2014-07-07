class ChessPiece
  
  attr_reader :captured, :position, :board, :team, :possible_moves
  
  def initialize( file, rank, team, board )
    @position = Position.new( file, rank )
    @board = board
    @team = team
    @captured = false
    @possible_moves = []
  end
  
  def captured!
    @captured = !captured
  end
  
  def captured?
    captured
  end
  
  def update_piece_position( file, rank )
    position.update_position( file, rank )
  end

  def clear_moves!
    possible_moves.clear
  end
end