require 'spec_helper'

describe BoardView do
  
  let(:board) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let(:piece1) { double( board_marker: "♚") }
  let(:piece2) { double( board_marker: "♔") }
  let(:board_printer) { double() }
  let(:board_view) { described_class.new( board_printer ) }

  before(:each) do
    allow( board ).to receive( :chess_board ).and_return( board )
    board[0][0] = piece1
    board[5][2] = piece2
  end

  describe "#populate_new_board" do
    it "places the markers to the new board" do
      board_view.populate_new_board( board )
      expect( board_view.new_board[0][2] ).to eq( "♚" )
      expect( board_view.new_board[5][4] ).to eq( "♔" )
    end

    it "does nothing when there is no piece transferred" do
      board_view.populate_new_board( board )
      expect( board_view.new_board[5][5] ).to eq( "…" )
    end
  end

  describe "#display_board" do
    it "prints the board" do
      expect( board_printer ).to receive( :print_board )
      board_view.display_board( board )
    end

    it "populates the new board" do
      allow( board_printer ).to receive( :print_board )
      board_view.display_board( board )
      expect( board_view.new_board[0][2] ).to eq( "♚" )
    end
  end
end