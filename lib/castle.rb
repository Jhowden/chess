class Castle

  TEAM_COLOR_CASTLE_RANK_MAP = {black: 1, white: 8}

  CASTLE_QUEENSIDE_FILE_CONTAINER = ["d", "c", "b"]
  CASTLE_KINGSIDE_FILE_CONTAINER = ["f", "g"]

  POSSIBLE_ROOK_FILE_CONTAINER = ["a", "h"]

  attr_reader :game
  
  def initialize game 
    @game = game
  end

  def castle_queenside( king, rank, player, enemy_player )
    rook = find_piece_on_board( POSSIBLE_ROOK_FILE_CONTAINER.first, rank )
    if legal_to_castle?( king.move_counter, rook.move_counter, CASTLE_QUEENSIDE_FILE_CONTAINER, rank )
      kings_starting_position = copy_piece_position king
      attempt_to_castle( king, rook, CASTLE_QUEENSIDE_FILE_CONTAINER.first, CASTLE_QUEENSIDE_FILE_CONTAINER[1],
        rank, kings_starting_position, player, enemy_player )
    else
      piece_already_moved_message
      get_player_move_again( player, enemy_player )
    end
  end

  def castle_kingside( king, rank, player, enemy_player )
    rook = find_piece_on_board( POSSIBLE_ROOK_FILE_CONTAINER.last, rank )
    if legal_to_castle?( king.move_counter, rook.move_counter, CASTLE_KINGSIDE_FILE_CONTAINER, rank )
      kings_starting_position = copy_piece_position king
      attempt_to_castle( king, rook, CASTLE_KINGSIDE_FILE_CONTAINER.first, CASTLE_KINGSIDE_FILE_CONTAINER[1], 
        rank, kings_starting_position, player, enemy_player )
    else
      piece_already_moved_message
      get_player_move_again( player, enemy_player )
    end
  end

  def legal_to_castle?( king_movement_counter, rook_movement_counter, file_container, rank )
    [king_movement_counter, rook_movement_counter].all? { |counter| counter == 0 } &&
      spaces_between_king_and_rook_unoccupied?( file_container, rank )
  end

  private

  def attempt_to_castle( king, rook, first_file_move, second_file_move, rank, original_position, player, enemy_player )
    update_the_board!( king, first_file_move, rank, copy_piece_position( king ) )
    if check?( player, enemy_player )
      restart_player_turn( king, original_position, copy_piece_position( king ), player, enemy_player )
    else
      update_the_board!( king, second_file_move, rank, copy_piece_position( king ) )
      if check?( player, enemy_player )
        restart_player_turn( king, original_position, copy_piece_position( king ), player, enemy_player )
      else
        update_the_board!( rook, first_file_move, rank, copy_piece_position( rook ) )
        increase_king_and_rook_move_counters( king, rook )
      end
    end
  end

  def copy_piece_position( piece )
    piece.position.dup
  end

  def restart_player_turn( king, kings_starting_position, king_current_position, player, enemy_player )
    restore_board_to_original( king, kings_starting_position, king_current_position )
    illegal_to_castle_message
    get_player_move_again( player, enemy_player )
  end

  def get_player_move_again( player, enemy_player )
    game.start_player_move( player, enemy_player )
  end

  def increase_king_and_rook_move_counters( king, rook )
    [king, rook].each do |piece|
      piece.increase_move_counter!
    end
  end

  def piece_already_moved_message
    puts "Invalid attempt to castle."
  end

  def illegal_to_castle_message
    puts "Your king would be in check! You cannot castle."
  end

  def update_the_board!( piece, file, rank, piece_starting_position )
    game.update_the_board!( piece, file, rank, piece_starting_position )
  end

  def find_piece_on_board( file, rank )
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

  def unoccupied_space?( file, rank )
    piece = find_piece_on_board( file, rank )
    piece.respond_to?( :determine_possible_moves ) ? false : true
  end

  def spaces_between_king_and_rook_unoccupied?( file_container, rank )
    file_container.map { |file|
      unoccupied_space?( file, rank )
    }.all? { |boolean| boolean }
  end
end