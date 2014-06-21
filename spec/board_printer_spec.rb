require_relative 'spec_helper'

describe BoardPrinter do

  let(:board_printer) { described_class.new }
  let(:row) do
    ["╚", "═", "═", "…", "…"]
  end 
  let(:board) { Array.new( 8 ) { |cell| Array.new( 8 ) } }

  describe "#print_board" do
    it "prints the board" do
      expect( board ).to receive( :each )
      board_printer.print_board( board )
    end
  end

  describe "#print_row" do
    it "prints out the row" do
      expect( row ).to receive( :join ).with( "  " )
      board_printer.print_row row
    end
  end
end