# Figure out how to add things to the path instead of having to rely on location aware requires
require_relative 'chess_piece'

class Pawn < ChessPiece
  
  attr_reader :orientation, :board_marker
  
  def initialize( file, rank, team, board, orientation )
    super( file, rank, team, board )
    @orientation = orientation
    @board_marker = determine_board_marker
  end
  
  def determine_possible_moves
    clear_moves!
    
    possible_moves << piece_move_forward?
    possible_moves << piece_move_forward_diagonally?( :left )
    possible_moves << piece_move_forward_diagonally?( :right )
    
    possible_moves.compact!
  end

  def determine_board_marker
    team == :white ? "♙" : "♟"
  end
  
  private
  
  def piece_move_forward?
    if board.move_straight?( self )
      if orientation == :down
        [position.file, position.rank - 1]
      else
        [position.file, position.rank + 1]
      end
    end
  end
  
  def piece_move_forward_diagonally?( direction )
    if orientation == :up
      if direction == :left && board.move_forward_diagonally?( self, :left )
        [new_file_position( :previous ), position.rank + 1]
      elsif direction == :right && board.move_forward_diagonally?( self, :right )
        [new_file_position( :next ), position.rank + 1]
      end
    else
      if direction == :left && board.move_forward_diagonally?( self, :left )
        [new_file_position( :next ), position.rank - 1]
      elsif direction == :right && board.move_forward_diagonally?( self, :right )
        [new_file_position( :previous ), position.rank - 1]
      end
    end
  end

    def new_file_position( navigation )
    if navigation == :previous
      Position::FILE_POSITIONS[Position::FILE_POSITIONS.index(position.file) - 1]
    else
      Position::FILE_POSITIONS[Position::FILE_POSITIONS.index(position.file) + 1]
    end
  end
end
