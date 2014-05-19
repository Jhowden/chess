require "spec_helper"
require_relative "../lib/position"

describe Queen do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:queen) { described_class.new( "♕", "e", 4, :black, board ) }
  
  before (:each) do
    allow( queen.possible_moves ).to receive( :clear )
  end

  describe "#determine_possible_moves" do
    it "returns an array of possible locations" do
      expect( board ).to receive( :find_horizontal_spaces ).with( queen ).
        and_return( [[3, 4], [4, 3], [5, 3]] )
        expect( board ).to receive( :find_vertical_spaces ).with( queen ).
        and_return( [[3, 5]] )
        expect( board ).to receive( :find_diagonal_spaces ).with( queen ).
        and_return( [[5, 4], [4, 5]] )
      queen.determine_possible_moves
      expect( queen.possible_moves.size ).to eq( 6 )
    end
  end
end