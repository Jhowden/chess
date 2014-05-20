require_relative 'chess_piece'

class Pawn < ChessPiece
  
  attr_reader :orientation
  
  def initialize( marker, file, rank, team, board, orientation )
    super( marker, file, rank, team, board )
    @orientation = orientation
  end
  
  def determine_possible_moves
    possible_moves.clear unless possible_moves.empty?
    
    possible_moves << piece_move_forward? if piece_move_forward? != nil
    possible_moves << piece_move_forward_diagonally?( :left ) if piece_move_forward_diagonally?( :left ) != nil
    possible_moves << piece_move_forward_diagonally?( :right ) if piece_move_forward_diagonally?( :right ) != nil
    
    possible_moves
  end
  
  private
  
  def piece_move_forward?
    if board.move_straight?( self )
      [position.file, position.rank + 1]
    end
  end
  
  def piece_move_forward_diagonally?( direction )
    if direction == :left && board.move_forward_diagonally?( self, :left )
      [new_file_position( :previous ), position.rank + 1]
    elsif direction == :right && board.move_forward_diagonally?( self, :right )
      [new_file_position( :next ), position.rank + 1]
    end
  end
end
