require 'spec_helper'

describe BoardPieceLocator do

  let(:board) { double() }
  let(:piece) { double() }
  let(:position) { stub_const "Position", Class.new}
  let(:game) { Game.new( board ).extend( described_class ) }

  describe "#find_piece_on_board" do
    context "when a piece is found" do
      it "finds the piece on the board" do
        expect( board ).to receive( :find_piece ).with position
        game.find_piece_on_board( position )
      end
    end

    context "when not finding a piece" do
      it "returns a NullPiece object" do
         allow( board ).to receive( :find_piece ).with( position ).and_return nil
         expect( game.find_piece_on_board( position ) ).to be_an_instance_of NullPiece
      end
    end
  end

  describe "#update_piece_on_board" do
    it "updates the piece on the board" do
      expect( board ).to receive( :update_board ).with( piece )
      game.update_piece_on_board piece 
    end
  end

  describe "#remove_piece_old_position" do
    it "removes a piece's old location from the board" do
      expect( board ).to receive( :remove_old_position ).with piece
      game.remove_piece_old_position piece 
    end
  end
end