module PawnBoardMoves
  UP_LEFT_MOVE_MODIFIERS = [-1, -1]
  UP_RIGHT_MOVE_MODIFIERS = [1, -1]
  DOWN_LEFT_MOVE_MODIFIERS = [1, 1]
  DOWN_RIGHT_MOVE_MODIFIERS = [-1, 1]

  UP_STRAIGHT_ONE_SPACES_MOVE_MODIFIERS = [-1, -1]
  DOWN_STRAIGHT_ONE_SPACES_MOVE_MODIFIERS = [1, 1]
  UP_STRAIGHT_TWO_SPACES_MOVE_MODIFIERS = [-2, -2]
  DOWN_STRAIGHT_TWO_SPACES_MOVE_MODIFIERS = [2, 2]

  def move_straight_one_space?( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    if piece.orientation == :up
      can_move_straight?( file, rank, UP_STRAIGHT_ONE_SPACES_MOVE_MODIFIERS )
    else
      can_move_straight?( file, rank, DOWN_STRAIGHT_ONE_SPACES_MOVE_MODIFIERS )
    end
  end

  def move_straight_two_spaces?( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    if can_move_two_spaces?( :up, piece )
      can_move_straight?( file, rank, UP_STRAIGHT_TWO_SPACES_MOVE_MODIFIERS )
    elsif can_move_two_spaces?( :down, piece )
      can_move_straight?( file, rank, DOWN_STRAIGHT_TWO_SPACES_MOVE_MODIFIERS )
    else
      false
    end
  end
  
  def move_forward_diagonally?( piece, direction )
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    if piece.orientation == :up
      if direction == :left
        can_move_diagonally?( file, rank, UP_LEFT_MOVE_MODIFIERS, piece )
      else
        can_move_diagonally?( file, rank, UP_RIGHT_MOVE_MODIFIERS, piece )
      end
    else
      if direction == :left
        can_move_diagonally?( file, rank, DOWN_LEFT_MOVE_MODIFIERS, piece )
      else
        can_move_diagonally?( file, rank, DOWN_RIGHT_MOVE_MODIFIERS, piece )
      end
    end
  end

  private

  def can_move_two_spaces?( orientation, piece )
    piece.orientation == orientation && move_straight_one_space?( piece ) && 
        pawn_first_move?( piece.move_counter )
  end

  def can_move_straight?( file, rank, move_modifier )
    legal_move?( file, rank + move_modifier.first ) && empty_space?( file, rank + move_modifier.last )
  end

  def pawn_first_move?( piece_move_counter )
    piece_move_counter == 0
  end

  def can_move_diagonally?( file, rank, move_modifier, piece )
    legal_move?( file + move_modifier.first, rank + move_modifier.last ) && 
      !empty_space?( file + move_modifier.first, rank + move_modifier.last ) && 
        different_team?( file + move_modifier.first, rank + move_modifier.last, piece )
  end
end