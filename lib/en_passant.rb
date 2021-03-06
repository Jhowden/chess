$LOAD_PATH.unshift( File.expand_path(File.dirname( __FILE__ ) ) ) unless $LOAD_PATH.include?( File.expand_path(File.dirname( __FILE__ ) ) )
require "move_validations"

class EnPassant
  include MoveValidations
  attr_reader :game
  
  EN_PASSANT_WORD_MARKER = "e.p."
  
  DOWN_EN_PASSANT_RANK_COLLECTION = [4, 3]
  UP_EN_PASSANT_RANK_COLLECTION = [5, 6]
  
  DOWN_SPACE = -1
  UP_SPACE = 1
  
  def initialize( game )
    @game = game
  end
  
  def can_en_passant?( pawn, navigation )
    if pawn.orientation == :down
      check_for_enpassant( pawn, navigation, DOWN_EN_PASSANT_RANK_COLLECTION.first )
    else 
      check_for_enpassant( pawn, navigation, UP_EN_PASSANT_RANK_COLLECTION.first )
    end
  end
  
  def capture_pawn_en_passant!( pawn, navigation )
    if pawn.orientation == :down
      possible_move( pawn, navigation, DOWN_EN_PASSANT_RANK_COLLECTION.last )
    else
      possible_move( pawn, navigation, UP_EN_PASSANT_RANK_COLLECTION.last )
    end
  end
  
  def update_enemy_pawn_status_for_en_passant( enemy_pieces, team )
    if team == :black
      pieces = enemy_pieces.select { |piece| pawn_that_can_be_captured_through_en_passant( piece, 
                                                                          DOWN_EN_PASSANT_RANK_COLLECTION.first ) }
    else
     pieces = enemy_pieces.select { |piece| pawn_that_can_be_captured_through_en_passant( piece, 
                                                                          UP_EN_PASSANT_RANK_COLLECTION.first ) }
    end
     pieces.each { |piece| piece.update_en_passant_status! }
  end
  
  private
  
  def pawn_that_can_be_captured_through_en_passant( piece, rank )
    !piece.captured? && piece.is_a?( Pawn ) && piece.position.rank == rank && piece.move_counter == 1 && piece.can_be_captured_en_passant?
  end
  
  def possible_move( pawn, navigation, rank )
    [pawn.new_file_position( navigation ), rank, EN_PASSANT_WORD_MARKER]
  end
  
  def check_for_enpassant( pawn, navigation, rank )
    if is_legal_move?( pawn.position, navigation )
      enemy_position = convert_to_position( pawn.new_file_position( navigation ), rank )
      potential_enemy_pawn = game.find_piece_on_board( enemy_position )
      legal_to_perform_en_passant?( potential_enemy_pawn ) ? true : false
    else
      false
    end
  end
  
  def legal_to_perform_en_passant?( potential_enemy_pawn )
    potential_enemy_pawn.is_a?( Pawn ) && potential_enemy_pawn.move_counter == 1 && potential_enemy_pawn.can_be_captured_en_passant?
  end
  
  def convert_to_position( file, rank )
    Position.new( file, rank )
  end
  
  def is_legal_move?( position, navigation )
    if navigation == :previous
      file = check_space_adjacent_space( position, -1  )
      rank = position.rank_position_converter
    else
      file = check_space_adjacent_space( position, 1 )
      rank = position.rank_position_converter
    end
    legal_move?( file, rank )
  end
  
  def check_space_adjacent_space( position, counter )
    position.file_position_converter + counter
  end
end