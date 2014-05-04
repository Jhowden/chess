require_relative 'chess_piece'

describe ChessPiece do
  
  let(:board) { double() }
  let(:piece) { described_class.new( "Pawn", "a", 0, :white, board ) }
  let(:position) { double() }
  
  before :each do
    stub_const "Position", Class.new
    allow( Position ).to receive( :new ).with( "a", 0 ).and_return( Position )
  end

  describe "#piece_captured?" do
    it "returns the status of a piece" do
      expect( piece.piece_captured? ).to be_false
    end
  end
  
  describe "#piece_captured" do
    it "changes the status of a piece" do
      expect( piece.captured ).to be_false
      piece.piece_captured
      expect( piece.captured ).to be 
    end
  end
  
  describe "#update_position" do
    it "updates the position of the piece" do
      piece.update_position( position )
      expect( piece.position ).to eq( position )
    end
  end
end