# when inserting the converted indices to check the array, have to switch them around. For example "b",2 needs to be board.chess_board[6][1]

require_relative 'position'

describe Position do

  let(:position) { described_class.new( "a", 1 ) }
  
  it "displays the position's file" do
    expect( position.file ).to eq( "a" )
  end
  
  it "displays the position's rank" do
    expect( position.rank ).to eq( 1 )
  end
  
  describe "#file_position_converter" do
    it "converts a file position to a board index" do
      expect( position.file_position_converter ).to eq( 0 )
    end
  end
  
  describe "#rank_position_converter" do
    it "converts a rank position to a board index" do
      expect( position.rank_position_converter ).to eq( 7 )
    end
  end
end