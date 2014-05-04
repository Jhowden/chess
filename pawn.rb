# movement instance variable in the initialize method that is populated by an array of possible places that the piece can move. Call a method to populate this instance variable. Can update this for each piece of a team at the beginning of their turn. Can only move as far as their path is unblocked. Must be a spot before their team member or the spot of an opponent.

# A piece needs to know its movement (ie pawn can move forward one spot if no one is blocking its path or can move diagonally to capture a piece)

# Need to account for pieces that start on top and head down, not just peices that start at bottom and move up. What about an orientation variable that keeps track of N/S/E/W and then moves based on that...

# Board should have a method about diagonals (what is three digaonal spaces from here...)

require_relative 'chess_piece'

class Pawn < ChessPiece
  
  attr_reader :possible_moves
  
  def initialize( name, file, rank, team, board, orientation )
    super( name, file, rank, team, board )
    @orientation = orientation
    @possible_moves = []
  end
  
  def determine_possible_moves # will probably need to empty @possibe_moves at the beginning each time to make sure that it is always up to date
    possible_moves.clear
    
    possible_moves << piece_move_forward? if piece_move_forward? != nil
    possible_moves << piece_move_forward_diagonally?( :left ) if piece_move_forward_diagonally?( :left ) != nil
    possible_moves << piece_move_forward_diagonally?( :right ) if piece_move_forward_diagonally?( :right ) != nil
    
    possible_moves
  end
  
  private
  
  def piece_move_forward?
    if board.move_straight?( self ) # move_straight
      possible_move = Position.new( position.file, position.rank + 1 )
    end
  end
  
  def piece_move_forward_diagonally?( direction )
    if direction == :left && board.move_forward_diagonally?( self, :left )
      Position.new( new_file_position( :previous ), position.rank + 1 )
    elsif direction == :right && board.move_forward_diagonally?( self, :right )
      Position.new( new_file_position( :next ), position.rank + 1)
    end
  end
end
