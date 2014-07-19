require_relative 'determine_multiple_moves'
require_relative 'move_validations'
require_relative 'pawn_board_moves'

class Board
  include DetermineMultipleMoves
  include MoveValidations
  include PawnBoardMoves
  
  attr_reader :chess_board, :possible_moves
  
  def initialize
    @chess_board = create_board
    @possible_moves = []
  end
  
  def create_board
     Array.new( 8 ) { |cell| Array.new( 8 ) }
  end
  
  def remove_old_position( piece_position )
    file = piece_position.file_position_converter
    rank = piece_position.rank_position_converter
    chess_board[rank][file] = nil
  end
  
  def update_board( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    capture_piece( file, rank )
    chess_board[rank][file] = piece
  end

  def capture_piece( file, rank )
    chess_board[rank][file].captured! unless chess_board[rank][file].nil?
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
    find_surrounding_spaces( piece, Knight::KNIGHT_SPACE_MODIFIERS )
  end
  
  def find_king_spaces( piece )
    clear_possible_moves?
    find_surrounding_spaces( piece, King::KING_SPACE_MODIFIERS )
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