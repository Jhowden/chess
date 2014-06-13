require_relative 'spec_helper'

describe Checkmate do
  
  let(:game) { double() }
  let(:checkmate) { described_class.new( game ) }
  let(:king) { double() }
  let(:piece) { double( piece_captured?: false ) }
  let(:piece2) { double( piece_captured?: false ) }
  let(:piece3) { double( piece_captured?: false ) }
  let(:player) { double() }
  let(:player2) { double( team_pieces: [] ) }
  
  describe "#move_king_in_all_possible_spots" do
    it "checks to see where a king can move and not be in check" do
      # Shouldn't some of these "expects" be "allows." How will the future programmer know what is important? 
      allow( player ).to receive( :team_pieces ).and_return [piece]
      expect( game ).to receive( :board ).and_return game
      expect( game ).to receive( :dup ).and_return( Array.new( 8 ) { |cell| Array.new( 8 ) } )
      expect( game ).to receive( :convert_to_file_and_rank ).exactly( 6 ).times.and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      expect( player ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).exactly( 6 ).times
      expect( king ).to receive( :determine_possible_moves ).and_return( [["c", 4], ["d", 3], ["e", 3], ["e", 4], ["d", 5], ["c", 5]] )
      expect( game ).to receive( :move_piece! ).exactly( 6 ).times
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( checkmate ).to receive( :check? ).exactly( 6 ).times
      expect( game ).to receive( :replace_board ).exactly( 6 ).times
      expect( piece ).to receive( :replace_board ).exactly( 6 ).times
      checkmate.move_king_in_all_possible_spots( player, player2 )
      expect( checkmate.possible_moves ).to eq( [["c", 4], ["d", 3], ["e", 3], ["e", 4], ["d", 5], ["c", 5]] )
    end
  end
  
  describe "#determine_enemy_piece_map" do
    it "creates a map of the piece's who can capture the king" do
      allow( player ).to receive( :team_pieces ).and_return [piece]
      expect( piece ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 4], ["d", 5]] )
      expect( player2 ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).twice.and_return king
      expect( king ).to receive( :file ).and_return "b"
      expect( king ).to receive( :rank ).and_return 4
      expect( checkmate.determine_enemy_piece_map( player2, player ) ).to eq( { piece => [["a", 4], ["b", 4], ["d", 5]] } )
    end
    
    it "can handle multiple pieces that put the king in check" do
      allow( player ).to receive( :team_pieces ).and_return [piece, piece2]
      expect( piece ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 4], ["c", 5]] )
      expect( piece2 ).to receive( :determine_possible_moves ).and_return( [["h", 4], ["b", 4], ["b", 4]] )
      expect( player2 ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).exactly( 4 ).times.and_return king
      expect( king ).to receive( :file ).twice.and_return "b"
      expect( king ).to receive( :rank ).twice.and_return 4
      expect( checkmate.determine_enemy_piece_map( player2, player ) ).
        to eq( { piece => [["a", 4], ["b", 4], ["c", 5]], piece2 => [["h", 4], ["b", 4], ["b", 4]] } )
    end
  end
  
  describe "#capture_pieces_threatening_king" do
    
    it "checks to see if good pieces can capture the enemy piece threatening the king" do
      allow( piece ).to receive( :position ).and_return piece
      allow( piece ).to receive( :file ).and_return "a"
      allow( piece ).to receive( :rank ).and_return 5
      expect( game ).to receive( :board ).and_return game
      expect( game ).to receive( :dup ).and_return( Array.new( 8 ) { |cell| Array.new( 8 ) } )
      expect( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( checkmate ).to receive( :determine_enemy_piece_map ).with( player, player2 ).
        and_return( { piece => [["a", 4], ["b", 4], ["d", 5]] } )
      expect( game ).to receive( :convert_to_file_and_rank ).and_return [0, 3]
      expect( checkmate ).to receive( :check? ).and_return false
      expect( game ).to receive( :move_piece! )
      expect( piece2 ).to receive( :determine_possible_moves ).and_return( [["a", 5], ["a", 4], ["a", 3], ["a", 2], ["a", 1]] )
      expect( piece3 ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 3], ["c", 2], ["d", 1]] )
      expect( piece2 ).to receive( :position )
      expect( checkmate ).to receive( :replace_board_on_pieces_to_original )
      expect( checkmate ).to receive( :replace_board_on_game_to_original )
      checkmate.capture_pieces_threatening_king( player, player2 )
      expect( checkmate.possible_moves ).to eq( [["a", 5]] )
    end
    
    it "exits out of the method if there are more than one enemy piece that has the king in check" do
      expect( player ).to_not receive( :team_pieces )
      expect( checkmate ).to receive( :determine_enemy_piece_map ).with( player, player2 ).
        and_return( { piece => [["a", 4], ["b", 4], ["d", 5]], piece3 => [["a", 4], ["b", 3], ["c", 2], ["d", 1]] }  )
      checkmate.capture_pieces_threatening_king( player, player2 )
    end
  end
  
  describe "#block_enemy_piece" do
    it "checks to see if any good pieces can block the enemy piece threatening the king" do
      expect( game ).to receive( :board ).and_return game
      expect( game ).to receive( :dup ).and_return( Array.new( 8 ) { |cell| Array.new( 8 ) } )
      expect( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( checkmate ).to receive( :determine_enemy_piece_map ).with( player, player2 ).
        and_return( { piece => [["a", 4], ["a", 3], ["a", 2], ["a", 1]] } )
      expect( piece2 ).to receive( :determine_possible_moves ).and_return( [["a", 5], ["a", 4], ["a", 3], ["a", 2]] )
      expect( piece3 ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 3], ["c", 2], ["d", 1]] )
      expect( piece2 ).to receive( :position ).exactly( 3 ).times
      expect( piece3 ).to receive( :position )
      expect( game ).to receive( :move_piece! ).exactly( 4 ).times
      expect( checkmate ).to receive( :replace_board_on_pieces_to_original ).exactly( 4 ).times
      expect( checkmate ).to receive( :replace_board_on_game_to_original ).exactly( 4 ).times
      expect( checkmate ).to receive( :check? ).exactly( 4 ).times.and_return false
      expect( game ).to receive( :convert_to_file_and_rank ).exactly( 4 ).times.and_return [0, 3]
      checkmate.block_enemy_piece( player, player2 )
      expect( checkmate.possible_moves ).to eq( [["a", 4], ["a", 3], ["a", 2], ["a", 4]] )
    end
    
    it "exits out of the method if there are more than one enemy piece that has the king in check" do
      expect( player ).to_not receive( :team_pieces )
      expect( checkmate ).to receive( :determine_enemy_piece_map ).with( player, player2 ).
        and_return( { piece => [["a", 4], ["b", 4], ["d", 5]], piece3 => [["a", 4], ["b", 3], ["c", 2], ["d", 1]] }  )
      checkmate.block_enemy_piece( player, player2 )
    end
  end
end