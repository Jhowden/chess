require_relative 'king'
require_relative 'position'

describe King do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:king) { described_class.new( "W-Kg", "e", 4, :black, board ) }
  
  before (:each) do
    allow( king.possible_moves ).to receive( :clear )
  end

  describe "#determine_possible_moves" do
    it "returns an array of possible locations" do
      expect( board ).to receive( :find_king_spaces ).with( king ).and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      king.determine_possible_moves
      expect( king.possible_moves.size ).to eq( 6 )
    end
  end
end