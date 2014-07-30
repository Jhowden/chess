  module EnPassantMoves
  def en_passant_move_sequence( player, enemy_player, player_input )
    piece_position = convert_to_position( player_input[0], player_input[1] )
    piece = find_piece_on_board( piece_position )
    target_file, target_rank = convert_to_file_and_rank( player_input[2], player_input[3] )
    if player_and_piece_same_team?( piece, player )
      if check_move?( piece, [target_file , target_rank, EnPassant::EN_PASSANT_WORD_MARKER] )
          perform_en_passant_move( piece, player, enemy_player, target_file, target_rank, piece_position )
        else
          display_invalid_message( "You cannot perform an en passant at this time.", player, enemy_player )
      end
    else
      display_invalid_message( "That piece is not on your team.", player, enemy_player )
    end
  end
  
  def perform_en_passant_move( piece, player, enemy_player, target_file, target_rank, piece_position )
    piece_original_position = piece_position.dup
    enemy_piece = find_enemy_pawn_for_en_passant( piece, target_file, target_rank )
    capture_the_piece enemy_piece
    remove_piece_old_position( enemy_piece.position )
    update_the_board!( piece, target_file, target_rank, piece_position )
    check_to_see_if_player_move_put_own_king_in_check( player, enemy_player, piece, piece_original_position, target_file, target_rank, enemy_piece )
    increase_piece_move_counter( piece )
  end
  
  def update_enemy_pawn_status_for_en_passant( enemy_pieces, team )
    en_passant.update_enemy_pawn_status_for_en_passant( enemy_pieces, team )
  end
end