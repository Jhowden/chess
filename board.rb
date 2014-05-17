class Board
  KNIGHT_SPACE_MODIFIERS = [[-1, -2], [-2, -1], [1, -2], [2, -1], [-1, 2], [-2, 1], [1, 2], [2, 1] ]
  KING_SPACE_MODIFIERS = [[-1, 0], [-1, -1], [0, -1], [1, -1], [1, 0], [1,1], [0,1], [-1, 1]]
  
  attr_reader :chess_board, :possible_moves
  
  def initialize
    @possible_moves = []
  end
  
  def create_board
    @chess_board = Array.new( 8 ) { |cell| Array.new( 8 ) }
  end
  
  def legal_move?( file_position, column_position )
    check_move?( file_position ) && check_move?( column_position ) ? true : false
  end
  
  def update_board( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    chess_board[rank][file].captured unless chess_board[rank][file] == nil
    chess_board[rank][file] = piece
  end
  
  def move_straight?( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    
    if piece.orientation == :up 
      legal_move?( file, rank - 1 ) && empty_space?( file, rank - 1 )
    else
      legal_move?( file, rank + 1 ) && empty_space?( file, rank + 1 )
    end
  end
  
  def move_forward_diagonally?( piece, direction ) # this really only works for pawns
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    if piece.orientation == :up
      if direction == :left
        !empty_space?( file - 1, rank - 1 ) && different_team?( file - 1, rank - 1, piece ) && legal_move?( file - 1, rank - 1 )
      else
        !empty_space?( file + 1, rank - 1 ) && different_team?( file + 1, rank - 1, piece ) && legal_move?( file - 1, rank - 1 )
      end
    else
      if direction == :left
        !empty_space?( file + 1, rank + 1 ) && different_team?( file + 1, rank + 1, piece ) && legal_move?( file + 1, rank + 1 )
      else
        !empty_space?( file - 1, rank + 1 ) && different_team?( file - 1, rank + 1, piece ) && legal_move?( file + 1, rank + 1 )
      end
    end
  end
  
  def find_horizontal_spaces( piece ) # these methods just return an array of indices, not a position instance
    clear_possible_moves?
    
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    find_spaces_to_the_left( file, rank, piece )
    find_spaces_to_the_right( file, rank, piece )
     
    possible_moves
  end
  
  def find_vertical_spaces( piece ) # these methods just return an array of indices, not a position instance
    clear_possible_moves?
    
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    find_spaces_above( file, rank, piece )
    find_spaces_below( file, rank, piece )
    
    possible_moves
  end
  
  def find_diagonal_spaces( piece )
    clear_possible_moves?
    
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    find_spaces_diagonally_top_left( file, rank, piece )
    find_spaces_diagonally_top_right( file, rank, piece )
    find_spaces_diagonally_bottom_left( file, rank, piece )
    find_spaces_diagonally_bottom_right( file, rank, piece )
   
    possible_moves
  end
  
  def find_knight_spaces( piece )
    find_surrounding_spaces( piece, KNIGHT_SPACE_MODIFIERS )
  end
  
  def find_king_spaces( piece )
    find_surrounding_spaces( piece, KING_SPACE_MODIFIERS )
  end
  
  def convert_to_file_position( index )
    FILE_POSITIONS[index]
  end
  
  def convert_to_rank_position( index )
    ( index - 8 ).abs
  end
  
  def find_king( piece ) # I am unsure if this method is really necessary...
    rank_location = chess_board.detect{ |rank_location| rank_location.include?( piece ) }
    rank = chess_board.index( rank_location )
    file = rank_location.index( piece )
    [rank, file]
  end

  def valid_space?( file, rank, piece )
    empty_space?( file, rank ) || different_team?( file, rank, piece )
  end
  
  private
  
  def check_move?( cell )
    cell <= 7 && cell >= 0
  end
  
  def empty_space?( file, rank )
    chess_board[rank][file].nil?
  end
  
  def different_team?( file, rank, piece )
    chess_board[rank][file].team != piece.team
  end

  def clear_possible_moves?
    possible_moves.clear unless possible_moves.empty?
  end

  def find_surrounding_spaces( piece, modifier_array )
    clear_possible_moves?
    
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter

    modifier_array.each do |file_mod, rank_mod|
      new_rank = rank + rank_mod
      new_file = file + file_mod
    
      possible_moves << [convert_to_file_position( new_file ), convert_to_rank_position( new_rank )] if valid_space?( new_file, new_rank, piece )
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