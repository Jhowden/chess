require "spec_helper"
require_relative "../lib/position"

describe Knight do
  
  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:knight) { described_class.new( "♞", "e", 4, :black, board ) }
  
  before (:each) do
    allow( knight.possible_moves ).to receive( :clear )
  end
  
  describe "#determine_possible_moves" do
    it "returns all possible moves" do
      expect( board ).to receive( :find_knight_spaces ).with( knight ).and_return( [[3, 2], [2, 3], [5, 2], [6, 3], [3, 6], [2, 5], [5, 6], [6, 5]] )
      knight.determine_possible_moves
      expect( knight.possible_moves.size ).to eq ( 8 )
    end
  end
end