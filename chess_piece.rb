class ChessPiece
  
  FILE_POSITIONS = ["a", "b", "c", "d", "e", "f", "g", "h"]
  
  attr_reader :name, :captured, :position, :board, :team, :possible_moves
  
  def initialize( name, file, rank, team, board )
    @name = name
    @position = Position.new( file, rank )
    @board = board
    @team = team
    @captured = false
    @possible_moves = []
  end
  
  def piece_captured
    @captured = true
  end
  
  def piece_captured?
    captured
  end
  
  def update_position( new_position )
    @position = new_position
  end
  
  private
  
  def new_file_position( navigation )
    if navigation == :previous
      FILE_POSITIONS[FILE_POSITIONS.index(position.file) - 1]
    else
      FILE_POSITIONS[FILE_POSITIONS.index(position.file) + 1]
    end
  end
end