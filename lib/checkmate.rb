class Checkmate
  
  attr_reader :game, :possible_moves
  
  def initialize game
    @game = game
    @possible_moves = []
  end
    
  def move_king_in_all_possible_spots( player, enemy_player )
    original_board = make_copy_of_original_board
    king = player.king_piece
    possible_king_moves = king.determine_possible_moves
    possible_king_moves.each do |possible_move|
      target_file, target_rank = game.convert_to_file_and_rank( possible_move.first, possible_move.last )
      game.move_piece!( king, target_file, target_rank, king.position )
      if !check?( player, enemy_player )
        possible_moves << possible_move
      end
      replace_board_on_pieces_to_original( [player, enemy_player], original_board )
      replace_board_on_game_to_original( original_board )
    end
  end
  
  def enemy_possible_moves_map( player, enemy_player )
    possible_moves_map = {}
    king = player.king_piece
    enemy_player.team_pieces.each do |piece|
      next if piece.piece_captured?
      possible_moves = piece.determine_possible_moves
      if possible_moves.include?( [king.position.file, king.position.rank] )
        possible_moves_map[piece] = possible_moves
      end
    end
    possible_moves_map
  end
  
  def replace_board_on_pieces_to_original( players_array, original_board )
    players_array.each do |team|
      team.team_pieces.each do |piece|
        piece.replace_board( original_board )
      end
    end
  end
  
  def replace_board_on_game_to_original( original_board )
    game.replace_board( original_board )
  end
  
  def check?( player, enemy_player )
    game.player_in_check?( player, enemy_player )
  end
  
  private 
  
  def make_copy_of_original_board
    game.board.dup
  end
end