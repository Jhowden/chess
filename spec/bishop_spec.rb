require "spec_helper"

describe Bishop do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:bishop) { described_class.new( "e", 4, :black, board ) }
  let(:bishop2) { described_class.new( "e", 4, :white, board ) }

  describe "#determine_possible_moves" do
    it "returns all possible moves" do
      allow( board ).to receive( :find_diagonal_spaces ).with( bishop ).
        and_return( [[3, 3], [5, 3], [5, 5], [6, 6], [7, 7]] )
      bishop.determine_possible_moves
      expect( bishop.possible_moves.size ).to eq( 5 )
    end

    it "clears possible moves when not empty" do
      bishop.possible_moves << ["a", 3]
      allow( board ).to receive( :find_diagonal_spaces ).and_return( [["c", 3]] )
      bishop.determine_possible_moves
      expect( bishop.possible_moves ).to eq( [["c", 3]] )
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( bishop.board_marker ).to eq( "♝" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( bishop2.board_marker ).to eq( "♗" )
    end
  end
end