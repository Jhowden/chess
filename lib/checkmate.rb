class Checkmate
  
  attr_reader :game, :possible_moves
  
  def initialize game
    @game = game
    @possible_moves = []
  end
    
  def move_king_in_all_possible_spots( player, enemy_player )
    original_board = make_copy_of_original_board
    king = player.king_piece
    king.determine_possible_moves.each do |possible_move|
      target_file, target_rank = game.convert_to_file_and_rank( possible_move.first, possible_move.last )
      game.update_the_board!( king, target_file, target_rank, king.position )
      possible_moves << [king.position.file, king.position.rank].
        concat( possible_move ) unless check?( player, enemy_player )
      return_board_to_original_state( player, enemy_player, original_board)
    end
  end
  
  def capture_pieces_threatening_king( player, enemy_player )
    enemy_pieces_collection = determine_enemy_piece_map( player, enemy_player ).keys
    return if enemy_pieces_collection.size >= 2 # can't capture two enemy pieces in one move
    original_board = make_copy_of_original_board
    player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
      attempt_to_capture_enemy_piece( player, enemy_player, piece, enemy_pieces_collection, original_board )
    end
  end

  def attempt_to_capture_enemy_piece( player, enemy_player, piece, enemy_pieces_collection, original_board )
    piece_possible_moves = piece.determine_possible_moves
      if piece_possible_moves.include?( [enemy_pieces_collection.first.position.file, 
          enemy_pieces_collection.last.position.rank] )
        update_the_board!( piece, enemy_pieces_collection )
        track_possible_moves( piece, enemy_pieces_collection ) unless check?( player, enemy_player )
        return_board_to_original_state( player, enemy_player, original_board)
      end
  end

  def update_the_board!( piece, enemy_pieces_collection )
    target_file, target_rank = game.convert_to_file_and_rank( enemy_pieces_collection.first.position.file, 
      enemy_pieces_collection.last.position.rank )
    game.update_the_board!( piece, target_file, target_rank, piece.position )
  end

  def track_possible_moves( piece, enemy_pieces_collection )
    possible_moves << [piece.position.file, piece.position.rank].
      concat( [enemy_pieces_collection.first.position.file, 
      enemy_pieces_collection.last.position.rank] )
  end

  def return_board_to_original_state( player, enemy_player, original_board)
    replace_board_on_pieces_to_original( [player, enemy_player], original_board )
    replace_board_on_game_to_original( original_board )
  end
  
  def block_enemy_piece( player, enemy_player )
    possible_enemy_moves_collection = determine_enemy_piece_map( player, enemy_player )
    return if possible_enemy_moves_collection.keys.size >= 2
    original_board = make_copy_of_original_board
    player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
      piece_possible_moves = piece.determine_possible_moves
      possible_enemy_moves_collection.values.flatten( 1 ).each do |enemy_possible_move|
    	  if piece_possible_moves.include?( enemy_possible_move )
           target_file, target_rank = game.convert_to_file_and_rank( enemy_possible_move.first, 
              enemy_possible_move.last )
            game.update_the_board!( piece, target_file, target_rank, piece.position )
          if !check?( player, enemy_player )
    	      possible_moves << [piece.position.file, piece.position.rank].
              concat( [enemy_possible_move.first, enemy_possible_move.last] )
          end
          return_board_to_original_state( player, enemy_player, original_board)
    		end
      end    
    end
  end
  
  def determine_enemy_piece_map( player, enemy_player )
    enemy_piece_map = {}
    king = player.king_piece
    enemy_player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
      possible_moves = piece.determine_possible_moves
      if possible_moves.include?( [king.position.file, king.position.rank] )
        enemy_piece_map[piece] = possible_moves
      end
    end
    enemy_piece_map
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