require "spec_helper"

describe ChessPiece do
  
  let(:board) { double() }
  let(:board2) { double() }
  let(:piece) { described_class.new( "a", 0, :white, board ) }

  describe "#captured?" do
    it "returns the status of a piece" do
      expect( piece.captured? ).to be_false
    end
  end
  
  describe "#captured!" do
    it "changes the status of a piece" do
      expect( piece.captured ).to be_false
      piece.captured!
      expect( piece.captured ).to be 
    end
  end
  
  describe "#update_piece_position" do
    it "updates the position of the piece" do
      piece.update_piece_position( "e", 5 )
      expect( piece.position.file ).to eq( "e" )
      expect( piece.position.rank ).to eq( 5 )
    end
  end
  
  describe "#replace_board" do
    it "replaces the piece's board" do
      expect( piece.board ).to eq( board )
      piece.replace_board( board2 )
      expect( piece.board ).to eq( board2 )
    end
  end

  describe "#clear_moves!" do
    it "clears possible moves if not empty" do
      piece.possible_moves << ["a", 3]
      piece.clear_moves!
      expect( piece.possible_moves.size ).to eq( 0 )
    end
  end
end