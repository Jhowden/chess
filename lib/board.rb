require_relative 'determine_multiple_moves'
require_relative 'move_validations'

class Board # Pretty good
  include DetermineMultipleMoves
  include MoveValidations
  
  KNIGHT_SPACE_MODIFIERS = [[-1, -2], [-2, -1], [1, -2], [2, -1], [-1, 2], [-2, 1], [1, 2], [2, 1] ]
  KING_SPACE_MODIFIERS = [[-1, 0], [-1, -1], [0, -1], [1, -1], [1, 0], [1,1], [0,1], [-1, 1]]
  
  attr_reader :chess_board, :possible_moves
  
  def initialize
    @chess_board = create_board
    @possible_moves = []
  end
  
  def create_board
     Array.new( 8 ) { |cell| Array.new( 8 ) }
  end
  
  def remove_marker( piece_position )
    file = piece_position.file_position_converter
    rank = piece_position.rank_position_converter
    chess_board[rank][file] = nil
  end
  
  def update_board( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    chess_board[rank][file].piece_captured unless chess_board[rank][file] == nil
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
  
  def move_forward_diagonally?( piece, direction )
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    if piece.orientation == :up
      if direction == :left
        legal_move?( file - 1, rank - 1 ) && !empty_space?( file - 1, rank - 1 ) && different_team?( file - 1, rank - 1, piece ) 
      else
        legal_move?( file + 1, rank - 1 ) && !empty_space?( file + 1, rank - 1 ) && different_team?( file + 1, rank - 1, piece )
      end
    else
      if direction == :left
        legal_move?( file + 1, rank + 1 ) && !empty_space?( file + 1, rank + 1 ) && different_team?( file + 1, rank + 1, piece )
      else
        legal_move?( file - 1, rank + 1 ) && !empty_space?( file - 1, rank + 1 ) && different_team?( file - 1, rank + 1, piece )
      end
    end
  end
  
  def find_horizontal_spaces( piece )
    clear_possible_moves?
    
    file = piece.position.file_position_converter 
    rank = piece.position.rank_position_converter
    
    find_spaces_to_the_left( file, rank, piece )
    find_spaces_to_the_right( file, rank, piece )
     
    possible_moves
  end
  
  def find_vertical_spaces( piece )
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
    clear_possible_moves?
    find_surrounding_spaces( piece, KNIGHT_SPACE_MODIFIERS )
  end
  
  def find_king_spaces( piece )
    clear_possible_moves?
    find_surrounding_spaces( piece, KING_SPACE_MODIFIERS )
  end
  
  def convert_to_file_position( index )
    Position::FILE_POSITIONS[index]
  end
  
  def convert_to_rank_position( index )
    ( index - 8 ).abs
  end
  
  def find_piece( position )
    file = position.file_position_converter
    rank = position.rank_position_converter
    chess_board[rank][file]
  end
  
  def place_pieces_on_board( player )
    player.team_pieces.each do |piece|
      update_board( piece )
    end
  end
  
  private

  def clear_possible_moves?
    possible_moves.clear unless possible_moves.empty?
  end
end