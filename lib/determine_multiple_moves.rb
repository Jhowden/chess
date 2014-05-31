module DetermineMultipleMoves
  def find_surrounding_spaces( piece, modifier_array )
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter

    modifier_array.each do |file_mod, rank_mod|
      new_rank = rank + rank_mod
      new_file = file + file_mod
    
      possible_moves << [convert_to_file_position( new_file ), convert_to_rank_position( new_rank )] if legal_move?( new_file, new_rank ) && valid_space?( new_file, new_rank, piece )
    end

    possible_moves
  end
  
  def find_spaces_to_the_left( file, rank, piece )
    left_counter = 1
    while legal_move?( rank, file - left_counter )
      if empty_space?( file - left_counter, rank )
        possible_moves << [convert_to_file_position( file - left_counter ), convert_to_rank_position( rank )]
      elsif different_team?( file - left_counter, rank, piece )
        possible_moves << [convert_to_file_position( file - left_counter ), convert_to_rank_position( rank )]
        break
      else
        break
      end
      left_counter += 1
    end
  end
  
  def find_spaces_to_the_right( file, rank, piece )
    right_counter = 1
    while legal_move?( rank, file + right_counter )
      if empty_space?( file + right_counter, rank )
        possible_moves << [convert_to_file_position( file + right_counter ), convert_to_rank_position( rank )]
      elsif different_team?( file + right_counter, rank, piece )
        possible_moves << [convert_to_file_position( file + right_counter ), convert_to_rank_position( rank )]
        break
      else
        break
      end
      right_counter += 1
    end
  end
  
  def find_spaces_above( file, rank, piece )
    up_counter = 1
    while legal_move?( rank - up_counter, file )
      if empty_space?( file, rank - up_counter )
        possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank - up_counter )]
      elsif different_team?( file, rank - up_counter, piece )
        possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank - up_counter )]
        break
      else
        break
      end
      up_counter += 1
    end
  end
  
  def find_spaces_below( file, rank, piece )
    down_counter = 1
    while legal_move?( rank + down_counter, file )
      if empty_space?( file, rank + down_counter )
        possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank + down_counter )]
      elsif different_team?( file, rank + down_counter, piece )
        possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank + down_counter )]
        break
      else
        break
      end
      down_counter += 1
    end
  end
  
  def find_spaces_diagonally_top_left( file, rank, piece )
    up_counter = 1
    left_counter = 1 
    while legal_move?( rank - up_counter, file - left_counter )
      if empty_space?( file - left_counter, rank - up_counter )
        possible_moves << [convert_to_file_position( file - left_counter ), convert_to_rank_position( rank - up_counter )]
      elsif different_team?( file - left_counter, rank - up_counter, piece )
        possible_moves << [convert_to_file_position( file - left_counter ), convert_to_rank_position( rank - up_counter )]
        break
      else
        break
      end
      up_counter += 1
      left_counter += 1
    end
  end
  
  def find_spaces_diagonally_top_right( file, rank, piece )
    up_counter = 1
    right_counter = 1 
    while legal_move?( rank - up_counter, file + right_counter )
      if empty_space?( file + right_counter, rank - up_counter )
        possible_moves << [convert_to_file_position( file + right_counter ), convert_to_rank_position( rank - up_counter )]
      elsif different_team?( file + right_counter, rank - up_counter, piece )
        possible_moves << [convert_to_file_position( file + right_counter ), convert_to_rank_position( rank - up_counter )]
        break
      else
        break
      end
      up_counter += 1
      right_counter += 1
    end
  end
  
  def find_spaces_diagonally_bottom_left( file, rank, piece )
    down_counter = 1
    left_counter = 1 
    while legal_move?( rank + down_counter, file - left_counter )
      if empty_space?( file - left_counter, rank + down_counter )
        possible_moves << [convert_to_file_position( file - left_counter ), convert_to_rank_position( rank + down_counter )]
      elsif different_team?( file - left_counter, rank + down_counter, piece )
        possible_moves << [convert_to_file_position( file - left_counter ), convert_to_rank_position( rank + down_counter )]
        break
      else
        break
      end
      down_counter += 1
      left_counter += 1
    end
  end
  
  def find_spaces_diagonally_bottom_right( file, rank, piece )
    down_counter = 1
    right_counter = 1 
    while legal_move?( rank + down_counter, file + right_counter )
      if empty_space?( file + right_counter, rank + down_counter )
        possible_moves << [convert_to_file_position( file + right_counter ), convert_to_rank_position( rank + down_counter )]
      elsif different_team?( file + right_counter, rank + down_counter, piece )
        possible_moves << [convert_to_file_position( file + right_counter ), convert_to_rank_position( rank + down_counter )]
        break
      else
        break
      end
      down_counter += 1
      right_counter += 1
    end
  end
end