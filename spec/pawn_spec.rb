require "spec_helper"

describe Pawn do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:pawn) { described_class.new( "♟", "b", 2, :black, board, :up ) }
  
  before :each do
    allow( board ).to receive( :move_straight? )
    allow( board ).to receive( :move_forward_diagonally? )
    allow( pawn.possible_moves ).to receive( :clear )
  end

  describe "#determine_possible_moves" do
    context "when there are no diagonal enemies" do
      it "only has one possible move" do
        expect( board ).to receive( :move_straight? ).with( pawn ).and_return( true )
        expect( board ).to receive( :move_forward_diagonally? ).twice
    
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
  end
end