require "spec_helper"

describe Knight do
  
  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:knight) { described_class.new( "e", 4, :black, board ) }
  let(:knight2) { described_class.new( "g", 1, :white, board ) }
  
  describe "#determine_possible_moves" do
    it "returns all possible moves" do
      expect( board ).to receive( :find_knight_spaces ).with( knight ).and_return( [[3, 2], [2, 3], [5, 2], [6, 3], [3, 6], [2, 5], [5, 6], [6, 5]] )
      knight.determine_possible_moves
      expect( knight.possible_moves.size ).to eq ( 8 )
    end
    
    it "does NOT include positions off the board" do
      expect( board ).to receive( :find_knight_spaces ).with( knight ).and_return( [[6, 4], [5, 5], [5, 7]] )
      knight.determine_possible_moves
      expect( knight.possible_moves.size ).to eq ( 3 )
    end

    it "clears possible moves when not empty" do
      knight.possible_moves << ["a", 3]
      allow( board ).to receive( :find_knight_spaces ).and_return( [["c", 3]] )
      knight.determine_possible_moves
      expect( knight.possible_moves ).to eq( [["c", 3]] )
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( knight.board_marker ).to eq( "♞" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( knight2.board_marker ).to eq( "♘" )
    end
  end
end