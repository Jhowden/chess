module MoveValidations
  def check_move?( cell )
    cell <= 7 && cell >= 0
  end
  
  def empty_space?( file, rank )
    chess_board[rank][file].nil?
  end
  
  def different_team?( file, rank, piece )
    chess_board[rank][file].team != piece.team
  end
  
  def valid_space?( file, rank, piece )
    empty_space?( file, rank ) || different_team?( file, rank, piece )
  end
  
  def legal_move?( file_position, rank_position )
    check_move?( file_position ) && check_move?( rank_position ) ? true : false
  end
end