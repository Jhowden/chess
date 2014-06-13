class ChessPiece
  
  FILE_POSITIONS = ["a", "b", "c", "d", "e", "f", "g", "h"]
  
  #What is marker?
  attr_reader :marker, :captured, :position, :board, :team, :possible_moves
  
  def initialize( marker, file, rank, team, board )
    @marker = marker
    @position = Position.new( file, rank )
    @board = board
    @team = team
    @captured = false
    @possible_moves = []
  end
  
  # Perhaps "capture!" is a better name. This seems like a question from its name
  def piece_captured
    @captured = true
  end
  
  def piece_captured?
    captured
  end
  
  def update_piece_position( file, rank )
    position.update_position( file, rank )
  end
  
  def replace_board new_board
    @board = new_board
  end
  
  private
  
  # If only the Pawn uses this method why is it here?
  def new_file_position( navigation )
    if navigation == :previous
      FILE_POSITIONS[FILE_POSITIONS.index(position.file) - 1]
    else
      FILE_POSITIONS[FILE_POSITIONS.index(position.file) + 1]
    end
  end
end