module BoardPieceLocator

  def find_piece_on_board( piece_position )
    piece = board.find_piece( piece_position )
    piece || NullPiece.new
  end

  def update_piece_on_board( piece )
    board.update_board( piece )
  end

  def remove_piece_old_position( piece_position )
    board.remove_old_position( piece_position )
  end
end