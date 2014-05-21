require_relative 'spec_helper'

describe BoardInterface do
  
  let(:board) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let(:piece1) { double( marker: "♚") }
  let(:piece2) { double( marker: "♔") }
  let(:row) { double() }
  let(:board_interface) { described_class.new }

  before(:each) do
    allow( board_interface ).to receive( :puts )
    allow( board_interface ).to receive( :print )
    allow( board ).to receive( :chess_board ).and_return( board )
    board[0][0] = piece1
    board[5][2] = piece2
  end

  describe "#populate_new_board" do
    it "places the markers to the new board" do
      board_interface.populate_new_board( board )
      expect( board_interface.new_board[0][2] ).to eq( "♚" )
      expect( board_interface.new_board[5][4] ).to eq( "♔" )
    end

    it "does nothing when there is no piece transferred" do
      board_interface.populate_new_board( board )
      expect( board_interface.new_board[5][5] ).to eq( "…" )
    end
  end

  describe "#print_board" do
    it "prints the board" do
      expect( board_interface.new_board ).to receive( :each ).and_yield( row )
      expect( row ).to receive( :join ).with( " " )
      board_interface.print_board
    end
  end
  
  describe "#display_board" do
    it "displays the board" do
      expect( board_interface ).to receive(  :remove_markers )
      expect( board_interface ).to receive( :populate_new_board ).with( board )
      expect( board_interface ).to receive(  :print_board )
      board_interface.display_board( board )
    end
  end
end