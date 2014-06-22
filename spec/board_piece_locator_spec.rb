require_relative 'spec_helper'

describe BoardPieceLocator do

  let(:board) { double() }
  let(:piece) { double() }
  let(:position) { stub_const "Position", Class.new}
  let(:game) { Game.new( board ).extend( described_class ) }

  describe "#find_piece_on_board" do
    it "finds the piece on the board" do
      expect( board ).to receive( :find_piece ).with position
      game.find_piece_on_board( position )
    end
  end

  describe "#update_piece_on_board" do
    it "updates the piece on the board" do
      expect( board ).to receive( :update_board ).with piece
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