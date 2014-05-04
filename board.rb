class Board
  
  attr_reader :chess_board, :possible_moves
  
  def initialize
    @possible_moves = []
  end
  
  def create_board
    @chess_board = Array.new( 8 ) { |cell| Array.new( 8 ) }
  end
  
  def legal_move?( row_position, column_position )
    check_move?( row_position ) && check_move?( column_position ) ? true : false
  end
  
  def move_or_capture_piece( piece ) # rename update board?
    row = piece.position.file_position_converter
    column = piece.position.rank_position_converter
    @captured_piece = chess_board[column][row]
    chess_board[column][row] = piece
    
    @captured_piece
  end
  
  def move_straight?( piece )
    row = piece.position.file_position_converter
    column = piece.position.rank_position_converter
    
    if piece.orientation == :up 
      legal_move?( row, column - 1 ) && empty_space?( column - 1, row ) # think about moving out this logic
    else
      legal_move?( row, column + 1 ) && empty_space?( column + 1, row )
    end
  end
  
  def move_forward_diagonally?( piece, direction ) # this really only works for pawns
    row = piece.position.file_position_converter 
    column = piece.position.rank_position_converter
    
    if piece.orientation == :up
      if direction == :left
        !empty_space?( column - 1, row - 1 ) && different_team?( column - 1, row - 1, piece ) && legal_move?( column - 1, row - 1 )
      else
        !empty_space?( column - 1, row + 1 ) && different_team?( column - 1, row + 1, piece ) && legal_move?( column - 1, row - 1 )
      end
    else
      if direction == :left
        !empty_space?( column + 1, row + 1 ) && different_team?( column + 1, row + 1, piece ) && legal_move?( column + 1, row + 1 )
      else
        !empty_space?( column + 1, row - 1 ) && different_team?( column + 1, row - 1, piece ) && legal_move?( column + 1, row + 1 )
      end
    end
  end
  
  def find_horizontal_spaces( piece ) # these methods just return an array of indices, not a position instance
    possible_moves.clear unless possible_moves.empty?
    
    row = piece.position.file_position_converter 
    column = piece.position.rank_position_converter
    
    find_spaces_to_the_left( column, row, piece )
    find_spaces_to_the_right( column, row, piece )
     
    possible_moves
  end
  
  def find_vertical_spaces( piece ) # these methods just return an array of indices, not a position instance
    possible_moves.clear unless possible_moves.empty?
    
    row = piece.position.file_position_converter 
    column = piece.position.rank_position_converter
    
    find_spaces_above( column, row, piece )
    find_spaces_below( column, row, piece )
    
    possible_moves
  end
  
  def find_diagonal_spaces( piece )
    possible_moves.clear unless possible_moves.empty?
    
    row = piece.position.file_position_converter 
    column = piece.position.rank_position_converter
    
    find_spaces_diagonally_top_left( column, row, piece )
    find_spaces_diagonally_top_right( column, row, piece )
    find_spaces_diagonally_bottom_left( column, row, piece )
    find_spaces_diagonally_bottom_right( column, row, piece )
    
    possible_moves
  end
   
   # def update_board( piece )
   #   if legal_move?( piece )
   #     move_or_capture( piece )
   #   else
   #     gets.chomp
   #   end
   # end
  
  private
  
  def check_move?( cell )
    cell <= 7 && cell >= 0
  end
  
  def empty_space?( column, row )
    chess_board[column][row].nil?
  end
  
  def different_team?( column, row, piece )
    chess_board[column][row].team != piece.team
  end
  
  def find_spaces_to_the_left( column, row, piece )
    left_counter = 1
    while legal_move?( column, row - left_counter )
      if empty_space?( column, row - left_counter )
        possible_moves << [column, row - left_counter]
      elsif different_team?( column, row - left_counter, piece )
        possible_moves << [column, row - left_counter]
        break
      else
        break
      end
      left_counter += 1
    end
  end
  
  def find_spaces_to_the_right( column, row, piece )
    right_counter = 1
    while legal_move?( column, row + right_counter )
      if empty_space?( column, row + right_counter )
        possible_moves << [column, row + right_counter]
      elsif different_team?( column, row + right_counter, piece )
        possible_moves << [column, row + right_counter]
        break
      else
        break
      end
      right_counter += 1
    end
  end
  
  def find_spaces_above( column, row, piece )
    up_counter = 1
    while legal_move?( column - up_counter, row )
      if empty_space?( column - up_counter, row )
        possible_moves << [column - up_counter, row ]
      elsif different_team?( column - up_counter, row, piece )
        possible_moves << [column - up_counter, row ]
        break
      else
        break
      end
      up_counter += 1
    end
  end
  
  def find_spaces_below( column, row, piece )
    down_counter = 1
    while legal_move?( column + down_counter, row )
      if empty_space?( column + down_counter, row )
        possible_moves << [column + down_counter, row ]
      elsif different_team?( column + down_counter, row, piece )
        possible_moves << [column + up_counter, row ]
        break
      else
        break
      end
      down_counter += 1
    end
  end
  
  def find_spaces_diagonally_top_left( column, row, piece )
    up_counter = 1
    left_counter = 1 
    while legal_move?( column - up_counter, row - left_counter )
      if empty_space?( column - up_counter, row - left_counter )
        possible_moves << [column - up_counter, row - left_counter ]
      elsif different_team?( column - up_counter, row - left_counter, piece )
        possible_moves << [column - up_counter, row - left_counter ]
        break
      else
        break
      end
      up_counter += 1
      left_counter += 1
    end
  end
  
  def find_spaces_diagonally_top_right( column, row, piece )
    up_counter = 1
    right_counter = 1 
    while legal_move?( column - up_counter, row + right_counter )
      if empty_space?( column - up_counter, row + right_counter )
        possible_moves << [column - up_counter, row + right_counter ]
      elsif different_team?( column - up_counter, row + right_counter, piece )
        possible_moves << [column - up_counter, row + right_counter ]
        break
      else
        break
      end
      up_counter += 1
      right_counter += 1
    end
  end
  
  def find_spaces_diagonally_bottom_left( column, row, piece )
    down_counter = 1
    left_counter = 1 
    while legal_move?( column + down_counter, row - left_counter )
      if empty_space?( column + down_counter, row - left_counter )
        possible_moves << [column + down_counter, row - left_counter ]
      elsif different_team?( column + down_counter, row - left_counter, piece )
        possible_moves << [column + down_counter, row - left_counter ]
        break
      else
        break
      end
      down_counter += 1
      left_counter += 1
    end
  end
  
  def find_spaces_diagonally_bottom_right( column, row, piece )
    down_counter = 1
    right_counter = 1 
    while legal_move?( column + down_counter, row + right_counter )
      if empty_space?( column + down_counter, row + right_counter )
        possible_moves << [column + down_counter, row + right_counter ]
      elsif different_team?( column + down_counter, row + right_counter, piece )
        possible_moves << [column + down_counter, row + right_counter ]
        break
      else
        break
      end
      down_counter += 1
      right_counter += 1
    end
  end
end