class Checkmate
  
  attr_reader :game, :possible_moves
  
  def initialize game
    @game = game
    @possible_moves = []
  end
    
  def move_king_in_all_possible_spots( player, enemy_player )
    king = player.king_piece
    king.determine_possible_moves.each do |possible_move|
      target_file, target_rank = possible_move.first, possible_move.last
      piece = captured_a_piece?( target_file, target_rank )
      if piece
        attempt_to_move_out_of_check( king, target_file, target_rank, player, enemy_player )
        restore_captured_piece_on_board piece
      else
        attempt_to_move_out_of_check( king, target_file, target_rank, player, enemy_player )
      end
    end
  end
  
  def capture_piece_threatening_king( player, enemy_player )
    enemy_pieces_collection = determine_enemy_piece_map( player, enemy_player ).keys
    return if enemy_pieces_collection.size >= 2 # can't capture two enemy pieces in one move
    player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
      attempt_to_capture_enemy_piece( player, enemy_player, piece, enemy_pieces_collection )
    end
  end
  
  def block_enemy_piece( player, enemy_player )
    possible_enemy_moves_collection = determine_enemy_piece_map( player, enemy_player )
    return if possible_enemy_moves_collection.keys.size >= 2
    player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
      attempt_to_block_enemy_piece( player, enemy_player, piece, possible_enemy_moves_collection )
    end
  end
  
  def determine_enemy_piece_map( player, enemy_player )
    enemy_piece_map = {}
    king = player.king_piece
    enemy_player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
      possible_piece_moves = piece.determine_possible_moves
      if possible_piece_moves.include?( [king.position.file, king.position.rank] )
        enemy_piece_map[piece] = possible_piece_moves
      end
    end
    enemy_piece_map
  end
  
  def find_checkmate_escape_moves( player, enemy_player )
    possible_moves.clear
    move_king_in_all_possible_spots( player, enemy_player )
    capture_piece_threatening_king( player, enemy_player )
    block_enemy_piece( player, enemy_player )
    possible_moves.uniq.map { |move| move.join }
  end
  
  private 
  
  def restore_piece_to_original_position( piece, piece_starting_position )
    pieces_temporary_position = piece.position.dup
    update_the_board!( piece, piece_starting_position.file, piece_starting_position.rank, pieces_temporary_position )
  end
  
  def attempt_to_capture_enemy_piece( player, enemy_player, piece, enemy_pieces_collection )
    piece_possible_moves = piece.determine_possible_moves
    enemy_location = [enemy_pieces_collection.first.position.file, 
                  enemy_pieces_collection.last.position.rank]
    if piece_possible_moves.include?( enemy_location )
      move_the_piece!( piece, enemy_location, player, enemy_player )
      restore_captured_piece_on_board enemy_pieces_collection.first
    end
  end
  
  def restore_captured_piece_on_board( enemy_piece )
    game.board.update_board enemy_piece
    enemy_piece.captured!
  end
  
  def attempt_to_block_enemy_piece( player, enemy_player, piece, possible_enemy_moves_collection )
    piece_possible_moves = piece.determine_possible_moves
    possible_enemy_moves_collection.values.flatten( 1 ).each do |possible_enemy_move|
      if piece_possible_moves.include?( possible_enemy_move )
        move_the_piece!( piece, possible_enemy_move, player, enemy_player )
      end
    end
  end
  
  def update_the_board!( piece, file, rank, piece_starting_position )
    game.update_the_board!( piece, file, rank, piece_starting_position )
  end
  
  def track_possible_moves( piece, location, piece_starting_position )
    possible_moves << [piece_starting_position.file, piece_starting_position.rank].
      concat( location ) 
  end
  
  def move_the_piece!( piece, possible_enemy_move, player, enemy_player )
    piece_starting_position = piece.position.dup
    update_the_board!( piece, possible_enemy_move.first, possible_enemy_move.last, piece_starting_position )
    track_possible_moves( piece, possible_enemy_move, piece_starting_position ) unless check?( player, enemy_player )
    restore_piece_to_original_position( piece, piece_starting_position )
  end
  
  def check?( player, enemy_player )
    game.player_in_check?( player, enemy_player )
  end
  
  def captured_a_piece?( file, rank )
    position = game.convert_to_position( file, rank )
    piece = game.find_piece_on_board( position )
    piece.respond_to?( :determine_possible_moves ) ? piece : false
  end
  
  def attempt_to_move_out_of_check( king, target_file, target_rank, player, enemy_player )
    move_the_piece!( king, [target_file, target_rank], player, enemy_player )
  end
end