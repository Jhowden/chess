module MoveMultipleSpaces
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
  
  def find_possible_horizontal_spaces( file, rank, piece, counter )
    horizontal_counter = counter
    while legal_move?( rank, file + horizontal_counter )
      if empty_space?( file + horizontal_counter, rank )
        possible_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank )]
      elsif different_team?( file + horizontal_counter, rank, piece )
        possible_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank )]
        break
      else
        break
      end
      horizontal_counter += counter
    end
  end
  
  def find_possible_vertical_spaces( file, rank, piece, counter )
    vertical_counter = counter
    while legal_move?( rank + vertical_counter, file )
      if empty_space?( file, rank + vertical_counter )
        possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank + vertical_counter )]
      elsif different_team?( file, rank + vertical_counter, piece )
        possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank + vertical_counter )]
        break
      else
        break
      end
      vertical_counter += counter
    end
  end
  
  def find_possible_diagonally_spaces( file, rank, piece, vert_counter, hor_counter )
    vertical_counter = vert_counter
    horizontal_counter = hor_counter
    while legal_move?( file + horizontal_counter, rank + vertical_counter )
      if empty_space?( file + horizontal_counter, rank + vertical_counter )
        possible_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank + vertical_counter )]
      elsif different_team?( file + horizontal_counter, rank + vertical_counter, piece )
        possible_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank + vertical_counter )]
        break
      else
        break
      end
      vertical_counter += vert_counter
      horizontal_counter += hor_counter
    end
  end
end