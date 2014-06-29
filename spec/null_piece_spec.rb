require_relative 'spec_helper'

describe NullPiece do

  let(:null_piece) { described_class.new }

  describe "#team" do
    it "returns false" do
      expect( null_piece.team ).to be_false
    end
  end
end