require 'spec_helper'

describe MoveValidations do
  subject { Board.new.extend( described_class ) }
  let(:piece) { double( position: Position.new( "e", 4 ), team: :black ) }
  
  describe "#valid_space?" do
    it "determines if a space can be occupied" do
      expect( subject.valid_space?( 3, 2, piece ) ).to be_true
    end
  end
  
  describe "#legal_move?" do
    it "detects if a piece is trying to be placed off the board" do
      expect( subject.legal_move?( 4, 6 ) ).to be
      expect( subject.legal_move?( 5, 8 ) ).to be_false
      expect( subject.legal_move?( 8, 0 ) ).to be_false
    end
  end

end