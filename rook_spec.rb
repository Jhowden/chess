require_relative "rook"
require_relative "position"

describe Rook do
  
  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:rook) { described_class.new( "W-Rk", "e", 4, :black, board ) }

  it "returns all the possibile moves" do
    expect( board ).to receive( :find_horizontal_spaces ).with( rook ).and_return( [[3,4], [2,4], [1,4], [5,4]] )
    expect( board ).to receive( :find_vertical_spaces ).with( rook ).and_return( [[4,3], [4,2], [4,5], [4,6]] )
    expect( rook.possible_moves ).to receive( :clear )
    rook.determine_possible_moves
    expect( rook.possible_moves.size ).to eq( 8 )
  end
  
end