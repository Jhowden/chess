require "spec_helper"

describe King do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:king) { described_class.new( "♔", "e", 4, :black, board ) }
  
  before (:each) do
    allow( king.possible_moves ).to receive( :clear )
  end

  describe "#determine_possible_moves" do
    it "returns an array of possible locations" do
      expect( board ).to receive( :find_king_spaces ).with( king ).and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      king.determine_possible_moves
      expect( king.possible_moves.size ).to eq( 6 )
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
end