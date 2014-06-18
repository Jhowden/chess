require "spec_helper"

describe King do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:king) { described_class.new( "e", 4, :black, board ) }
  let(:king2) { described_class.new( "e", 4, :white, board ) }

  describe "#determine_possible_moves" do
    it "returns an array of possible locations" do
      expect( board ).to receive( :find_king_spaces ).with( king ).and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      king.determine_possible_moves
      expect( king.possible_moves.size ).to eq( 6 )
    end

    it "clears possible moves when not empty" do
      king.possible_moves << ["a", 3]
      allow( board ).to receive( :find_king_spaces ).and_return( [["c", 3]] )
      king.determine_possible_moves
      expect( king.possible_moves ).to eq( [["c", 3]] )
    end
  end
  
  describe "check?" do
    it "determines if the king is in check" do
      expect( king.check?( [["e", 5], ["d", 4], ["e", 4], ["f", 4]] ) ).to be_true
    end
  end
  
  describe "#checkmated" do
    it "changes the status of checkmate" do
      expect( king.checkmate ).to be_false
      king.checkmated
      expect( king.checkmate ).to be_true
    end
  end
  
  describe "#checkmated?" do
    it "checks to see if a king is in checkmate" do
      expect( king.checkmated? ).to be_false
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( king.board_marker ).to eq( "♚" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( king2.board_marker ).to eq( "♔" )
    end
  end
end