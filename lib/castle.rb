# new class that takes in board
# check to see if in check and if rook and king have moved before
#   move king one space over, check if in check
#     if not in check
#       move over one more space
#         if not in check
#           move rook to the correct spot
#         else
#           don't allow move, reset board
#     else
#       don't allow move, reset board
# else
#   don't allow move, reset board

# what do I want input for castling be? (castle queenside/kingside)
# the only difference between teams is the rank (ie 1 for white, 8 for black), the files are the same

class Castle

  TEAM_COLOR_CASTLE_RANK_MAP = {black: 1, white: 8}
  CASTILE_QUEENSIDE_FILE_CONTAINER = ["d", "c"]
  POSSIBLE_ROOK_FILE_CONTAINER = ["a", "h"]

  attr_reader :game
  
  def initialize game 
    @game = game
  end

  def castle_queenside( king, rank, player, enemy_player )
    rook = find_rook_on_board( POSSIBLE_ROOK_FILE_CONTAINER.first, rank )
    if legal_to_castle?( king.move_counter, rook.move_counter )
      kings_starting_position = copy_piece_position king
      update_the_board!( king, CASTILE_QUEENSIDE_FILE_CONTAINER.first, rank, copy_piece_position( king ) )
      if check?( player, enemy_player )
        restart_player_turn( king, kings_starting_position, king.position, player, enemy_player )
      else
        update_the_board!( king, CASTILE_QUEENSIDE_FILE_CONTAINER.last, rank, copy_piece_position( king ) )
        if check?( player, enemy_player )
          restart_player_turn( king, kings_starting_position, king.position, player, enemy_player )
        else
          update_the_board!( rook, CASTILE_QUEENSIDE_FILE_CONTAINER.first, rank, copy_piece_position( rook ) )
          increase_king_and_rook_move_counters( king, rook )
        end
      end
    else
      piece_already_moved_message
      get_player_move_again( player, enemy_player )
    end
  end

  def legal_to_castle?( king_movement_counter, rook_movement_counter )
    [king_movement_counter, rook_movement_counter].all? { |counter| counter == 0 }
  end

  private

  def copy_piece_position( piece )
    piece.position.dup
  end

  def restart_player_turn( king, kings_starting_position, king_current_position, player, enemy_player )
    restore_board_to_original( king, kings_starting_position, king.position )
    illegal_to_castle_message
    get_player_move_again( player, enemy_player )
  end

  def get_player_move_again( player, enemy_player )
    game.start_player_move( player, enemy_player )
  end

  def increase_king_and_rook_move_counters( king, rook )
    [king, rook].each do |piece|
      game.increase_piece_move_counter( piece )
    end
  end

  def piece_already_moved_message
    puts "You can no longer castle as you have already moved either your rook or king."
  end

  def illegal_to_castle_message
    puts "Your king would be in check! You cannot castle."
  end

  def update_the_board!( piece, file, rank, piece_starting_position )
    game.update_the_board!( piece, file, rank, piece_starting_position )
  end

  def find_rook_on_board( file, rank )
    game.find_piece_on_board( convert_file_and_rank_to_position( file, rank ) )
  end

  def convert_file_and_rank_to_position( file, rank )
    Position.new( file, rank )
  end

  def check?( player, enemy_player )
    game.player_in_check?( player, enemy_player )
  end

  def restore_board_to_original( king, original_position, current_position )
    game.restore_piece_to_original_position( king, original_position, current_position )
  end
end