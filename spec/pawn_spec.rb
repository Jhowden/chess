require "spec_helper"

describe Pawn do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:pawn) { described_class.new( "b", 2, :black, board, :up ) }
  let(:pawn2) { described_class.new( "b", 1, :white, board, :down ) }
  
  before :each do
    allow( board ).to receive( :move_straight? )
    allow( board ).to receive( :move_forward_diagonally? ).twice
  end

  describe "#determine_possible_moves" do
    context "when there are no diagonal enemies" do
      it "only has one possible move" do
        expect( board ).to receive( :move_straight? ).with( pawn ).and_return( true )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 1 )
      end
    end

    context "when there is a diagonal enemy" do         
      it "returns only two possible moves" do
        expect( board ).to receive( :move_straight? ).with( pawn ).and_return( true )
        expect( board ).to receive( :move_forward_diagonally? ).with( pawn, :left ).and_return( false )
        expect( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( true )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 2 )
      end
      
      context "when on the edge of the board" do
        it "returns no possible moves" do
          expect( board ).to receive( :move_straight? ).with( pawn ).and_return( false )
          expect( board ).to receive( :move_forward_diagonally? ).with( pawn, :left ).and_return( false )
          expect( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( false )
    
          pawn.determine_possible_moves
          expect( pawn.possible_moves.size ).to eq( 0 )
        end
      end
    end
  
    context "when there is a diagonal friendly" do
      it "returns no possible moves" do
        expect( board ).to receive( :move_straight? ).with( pawn ).and_return( false )
        expect( board ).to receive( :move_forward_diagonally? ).with( pawn, :left ).and_return( false )
        expect( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 0 )
      end
    end
  
    context "when there is a piece straight ahead" do
      it "returns no possible moves" do
        expect( board ).to receive( :move_straight? ).with( pawn ).and_return( false )
        expect( board ).to receive( :move_forward_diagonally? )
        expect( board ).to receive( :move_forward_diagonally? )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 0 )
      end
    end

    it "clears possible moves when not empty" do
      pawn.possible_moves << ["a", 3]
      allow( board ).to receive( :move_straight? ).and_return( true )
      pawn.determine_possible_moves
      expect( pawn.possible_moves ).to eq( [["b", 3]] )
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( pawn.board_marker ).to eq( "♟" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( pawn2.board_marker ).to eq( "♙" )
    end
  end
end