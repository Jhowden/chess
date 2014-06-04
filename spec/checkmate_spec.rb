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
      allow( player ).to receive( :team_pieces ).and_return [piece]
      expect( game ).to receive( :board ).and_return game
      expect( game ).to receive( :dup ).and_return( Array.new( 8 ) { |cell| Array.new( 8 ) } )
      expect( game ).to receive( :convert_to_file_and_rank ).exactly( 6 ).times.and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      expect( player ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).exactly( 6 ).times
      expect( king ).to receive( :determine_possible_moves ).and_return( [["c", 4], ["d", 3], ["e", 3], ["e", 4], ["d", 5], ["c", 5]] )
      expect( game ).to receive( :move_piece! ).exactly( 6 ).times
      expect( game ).to receive( :player_in_check? ).exactly( 6 ).times
      expect( game ).to receive( :replace_board ).exactly( 6 ).times
      expect( piece ).to receive( :replace_board ).exactly( 6 ).times
      checkmate.move_king_in_all_possible_spots( player, player2 )
      expect( checkmate.possible_moves ).to eq( [["c", 4], ["d", 3], ["e", 3], ["e", 4], ["d", 5], ["c", 5]] )
    end
  end
  
  describe "#enemy_piece_collection" do
    it "creates a map of the piece's who can capture the king" do
      allow( player ).to receive( :team_pieces ).and_return [piece]
      expect( piece ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 4], ["d", 5]] )
      expect( player2 ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).twice.and_return king
      expect( king ).to receive( :file ).and_return "b"
      expect( king ).to receive( :rank ).and_return 4
      expect( checkmate.enemy_piece_collection( player2, player ) ).to eq( [piece] )
    end
    
    it "can handle multiple pieces that put the king in check" do
      allow( player ).to receive( :team_pieces ).and_return [piece, piece2]
      expect( piece ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 4], ["c", 5]] )
      expect( piece2 ).to receive( :determine_possible_moves ).and_return( [["h", 4], ["b", 4], ["b", 4]] )
      expect( player2 ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).exactly( 4 ).times.and_return king
      expect( king ).to receive( :file ).twice.and_return "b"
      expect( king ).to receive( :rank ).twice.and_return 4
      expect( checkmate.enemy_piece_collection( player2, player ) ).
        to eq( [piece, piece2] )
    end
  end
  
  describe "#capture_pieces_threatening_king" do
    
    before(:each) do
      allow( piece ).to receive( :position ).and_return piece
      allow( piece ).to receive( :file ).and_return "a"
      allow( piece ).to receive( :rank ).and_return 5
      allow( game ).to receive( :board ).and_return game
      allow( game ).to receive( :dup ).and_return( Array.new( 8 ) { |cell| Array.new( 8 ) } )
      allow( game ).to receive( :convert_to_file_and_rank ).and_return [0, 3]
      allow( game ).to receive( :move_piece! )
      allow( game ).to receive( :player_in_check? ).and_return false
      allow( checkmate ).to receive( :replace_board_on_pieces_to_original )
      allow( checkmate ).to receive( :replace_board_on_game_to_original )
    end
    
    it "checks to see if good pieces can capture the enemy piece threatening the king" do
      expect( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
      expect( checkmate ).to receive( :enemy_piece_collection ).with( player, player2 ).
        and_return( [piece] )
      expect( piece2 ).to receive( :determine_possible_moves ).and_return( [["a", 5], ["a", 4], ["a", 3], ["a", 2], ["a", 1]] )
      expect( piece3 ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 3], ["c", 2], ["d", 1]] )
      expect( piece2 ).to receive( :position )
      checkmate.capture_pieces_threatening_king( player, player2 )
      expect( checkmate.possible_moves ).to eq( [["a", 5]] )
    end
    
    it "exits out of the method if there is more than one enemy piece that has the king in check" do
      expect( player ).to_not receive( :team_pieces )
      expect( checkmate ).to receive( :enemy_piece_collection ).with( player, player2 ).
        and_return( [piece, piece3] )
      checkmate.capture_pieces_threatening_king( player, player2 )
    end
  end
end