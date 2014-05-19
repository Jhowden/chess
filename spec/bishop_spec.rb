require "spec_helper"
require_relative "../lib/position"

describe Bishop do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:bishop) { described_class.new( "♝", "e", 4, :black, board ) }
  
  before (:each) do
    allow( bishop.possible_moves ).to receive( :clear )
  end
  
  describe "#determine_possible_moves" do
    it "returns all possible moves" do
      expect( board ).to receive( :find_diagonal_spaces ).with( bishop ).and_return( [[3, 3], [5, 3], [5, 5], [6, 6], [7, 7]] )
      bishop.determine_possible_moves
      expect( bishop.possible_moves.size ).to eq( 5 )
    end
  end
  
end