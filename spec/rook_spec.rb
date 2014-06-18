require "spec_helper"

describe Rook do
  
  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:rook) { described_class.new( "e", 4, :black, board ) }
  let(:rook2) { described_class.new( "e", 4, :white, board ) }

  describe "#determine_possible_moves" do
    it "returns all possibile moves" do
      expect( board ).to receive( :find_horizontal_spaces ).with( rook ).and_return( [[3,4], [2,4], [1,4], [5,4]] )
      expect( board ).to receive( :find_vertical_spaces ).with( rook ).and_return( [[4,3], [4,2], [4,5], [4,6]] )
      rook.determine_possible_moves
      expect( rook.possible_moves.size ).to eq( 8 )
    end

    it "clears possible moves when not empty" do
      rook.possible_moves << ["a", 3]
      allow( board ).to receive( :find_horizontal_spaces ).and_return( [["c",4]] )
      allow( board ).to receive( :find_vertical_spaces ).and_return( [["d",3]] )
      rook.determine_possible_moves
      expect( rook.possible_moves ).to eq( [["c", 4], ["d", 3]] )
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( rook.board_marker ).to eq( "♜" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( rook2.board_marker ).to eq( "♖" )
    end
  end
end