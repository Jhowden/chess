# Figure out how to add things to the path instead of having to rely on location aware requires
require_relative 'chess_piece'

class Pawn < ChessPiece
  STRAIGHT_ONE_MOVE_MODIFIER = [-1, 1]
  STRAIGHT_TWO_MOVE_MODIFIER = [-2, 2]
  
  attr_reader :orientation, :board_marker, :starting_location, :en_passant, :capture_through_en_passant
  
  def initialize( file, rank, team, board, orientation, en_passant )
    super( file, rank, team, board )
    @orientation = orientation
    @en_passant = en_passant
    @board_marker = determine_board_marker
    @starting_location = determine_starting_location
    @capture_through_en_passant = true
  end
  
  def determine_possible_moves
    clear_moves!
    
    possible_moves << piece_move_forward_one_space( STRAIGHT_ONE_MOVE_MODIFIER )
    possible_moves << piece_move_forward_two_spaces( STRAIGHT_TWO_MOVE_MODIFIER )
    possible_moves << piece_move_forward_diagonally( :left )
    possible_moves << piece_move_forward_diagonally( :right )
    possible_moves << en_passant.capture_pawn_en_passant!( self, :previous ) if en_passant.en_passant?( self, :previous )
    possible_moves << en_passant.capture_pawn_en_passant!( self, :next ) if en_passant.en_passant?( self, :next )
    
    possible_moves.compact!
  end

  def determine_board_marker
    team == :white ? "♙" : "♟"
  end
  
  def new_file_position( navigation )
    if navigation == :previous
      Position::FILE_POSITIONS[Position::FILE_POSITIONS.index( position.file ) - 1]
    else
      Position::FILE_POSITIONS[Position::FILE_POSITIONS.index( position.file ) + 1]
    end
  end
  
  def update_en_passant_status!
    @capture_through_en_passant = false
  end
  
  def can_be_captured_en_passant?
    capture_through_en_passant
  end
  
  private
  
  def piece_move_forward_one_space( move_modifier ) # figure out how to combine this and #piece_move_forward_two_spaces methods together, pretty much exactly the same
    if board.move_straight_one_space?( self )
      if orientation == :down
        [position.file, position.rank + move_modifier.first]
      else
        [position.file, position.rank + move_modifier.last]
      end
    end
  end

  def piece_move_forward_two_spaces( move_modifier )
    if board.move_straight_two_spaces?( self )
      if orientation == :down
        [position.file, position.rank + move_modifier.first]
      else
        [position.file, position.rank + move_modifier.last]
      end
    end
  end
  
  def piece_move_forward_diagonally( direction )
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

  def determine_starting_location
    [position.file, position.rank]
  end
end
