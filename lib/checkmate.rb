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
        possible_moves << possible_move # pass in piece starting position and target position => ["a"3"b"4] so that I can ensure that when the player picks the king he chooses a correct spot
      end
      replace_board_on_pieces_to_original( [player, enemy_player], original_board )
      replace_board_on_game_to_original( original_board )
    end
  end
  
  def capture_pieces_threatening_king( player, enemy_player )
    enemy_pieces_threatening_king_collection = enemy_piece_collection( player, enemy_player )
    return if enemy_pieces_threatening_king_collection.size >= 2 # can't capture two enemy pieces in one move
    original_board = make_copy_of_original_board
    player.team_pieces.select{ |piece| !piece.piece_captured? }.each do |piece|
      piece_possible_moves = piece.determine_possible_moves
      if piece_possible_moves.include?( [enemy_pieces_threatening_king_collection.first.position.file, 
          enemy_pieces_threatening_king_collection.last.position.rank] )
        target_file, target_rank = game.convert_to_file_and_rank( enemy_pieces_threatening_king_collection.first.position.file, 
          enemy_pieces_threatening_king_collection.last.position.rank )
        game.move_piece!( piece, target_file, target_rank, piece.position )
        if !check?( player, enemy_player )
          possible_moves << [enemy_pieces_threatening_king_collection.first.position.file, 
            enemy_pieces_threatening_king_collection.last.position.rank] # pass in piece starting position and target position => ["a"3"b"4] so that I can ensure that when the player picks the piece he chooses a correct spot
        end
        replace_board_on_pieces_to_original( [player, enemy_player], original_board )
        replace_board_on_game_to_original( original_board )
      end
    end
  end
  
  def enemy_piece_collection( player, enemy_player )
    enemy_piece_collection = []
    king = player.king_piece
    enemy_player.team_pieces.select{ |piece| !piece.piece_captured? }.each do |piece|
      possible_moves = piece.determine_possible_moves
      if possible_moves.include?( [king.position.file, king.position.rank] )
        enemy_piece_collection << piece
      end
    end
    enemy_piece_collection
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