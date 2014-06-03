require_relative 'spec_helper'

describe Checkmate do
  
  let(:game) { double() }
  let(:checkmate) { described_class.new( game ) }
  let(:king) { double() }
  let(:piece) { double() }
  let(:piece2) { double() }
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
      expect( king ).to receive( :determine_possible_moves ).and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      expect( game ).to receive( :move_piece! ).exactly( 6 ).times
      expect( game ).to receive( :player_in_check? ).exactly( 6 ).times
      expect( game ).to receive( :replace_board ).exactly( 6 ).times
      expect( piece ).to receive( :replace_board ).exactly( 6 ).times
      checkmate.move_king_in_all_possible_spots( player, player2 )
      expect( checkmate.possible_moves.size ).to eq( 6 )
    end
  end
  
  describe "#enemy_possible_moves_map" do
    it "creates a map of the piece's who can capture the king" do
      allow( player ).to receive( :team_pieces ).and_return [piece]
      expect( piece ).to receive( :determine_possible_moves ).and_return( [[2, 4], [3, 4], [3, 5]] )
      expect( piece ).to receive( :piece_captured? ).and_return false
      expect( player2 ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).twice.and_return king
      expect( king ).to receive( :file ).and_return 3
      expect( king ).to receive( :rank ).and_return 4
      expect( checkmate.enemy_possible_moves_map( player2, player ) ).to eq( { piece => [[2, 4], [3, 4], [3, 5]] } )
    end
    
    it "can handle multiple pieces that put the king in check" do
      allow( player ).to receive( :team_pieces ).and_return [piece, piece2]
      expect( piece ).to receive( :determine_possible_moves ).and_return( [[2, 4], [3, 4], [3, 5]] )
      expect( piece2 ).to receive( :determine_possible_moves ).and_return( [[2, 4], [3, 4], [4, 4]] )
      expect( piece ).to receive( :piece_captured? ).and_return false
      expect( piece2 ).to receive( :piece_captured? ).and_return false
      expect( player2 ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).exactly( 4 ).times.and_return king
      expect( king ).to receive( :file ).twice.and_return 3
      expect( king ).to receive( :rank ).twice.and_return 4
      expect( checkmate.enemy_possible_moves_map( player2, player ) ).
        to eq( { piece => [[2, 4], [3, 4], [3, 5]], piece2 => [[2, 4], [3, 4], [4, 4]] } )
    end
  end
  
  describe "#capture_pieces_threatening_king" do
    it "checks to see if good pieces can capture the enemy pieces threatening the king" do
      # finds any pieces that have the king in check
      # can any of the good pieces capture those piece(s)
      # if they are two or more pieces that have the king in check, go to next step (can't capture two pieces at once)
    end
  end
end