class ChessPiece
  
  #What is marker?
  attr_reader :captured, :position, :board, :team, :possible_moves
  
  def initialize( file, rank, team, board )
    @position = Position.new( file, rank )
    @board = board
    @team = team
    @captured = false
    @possible_moves = []
  end
  
  def captured!
    @captured = true
  end
  
  def captured?
    captured
  end
  
  def update_piece_position( file, rank )
    position.update_position( file, rank )
  end
  
  def replace_board new_board
    @board = new_board
  end

  def clear_moves!
    possible_moves.clear unless possible_moves.empty?
  end
end