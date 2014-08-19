module PiecePromotion

  WHITE_PROMOTION_RANK = 1
  BLACK_PROMOTION_RANK = 8

  def pawn_can_be_promoted?( pawn )
    if pawn.team == :white
      pawn.position.rank == WHITE_PROMOTION_RANK
    else
      pawn.position.rank == BLACK_PROMOTION_RANK
    end
  end

  def replace_pawn_with_promoted_piece pawn 
    promoted_piece = create_new_piece pawn
    put_new_piece_on_board promoted_piece
  end

  private

  def pick_replacement_piece
    user_commands.piece_promotion_input
  end

  def create_new_piece pawn
    replacement_piece = pick_replacement_piece
    Object.const_get( replacement_piece ).new( pawn.position.file, 
                                               pawn.position.rank, 
                                               pawn.team, 
                                               board )
  end

  def put_new_piece_on_board promoted_piece 
    board.update_board promoted_piece
  end
end