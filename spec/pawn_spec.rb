require "spec_helper"

describe Pawn do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:pawn) { described_class.new( "b", 2, :black, board, :up, enpassant ) }
  let(:pawn2) { described_class.new( "b", 1, :white, board, :down, enpassant ) }
  let(:enpassant) { double() }
  
  before :each do
    allow( board ).to receive( :move_straight_one_space? )
    allow( board ).to receive( :move_straight_two_spaces? )
    allow( board ).to receive( :move_forward_diagonally? )
    allow( enpassant ).to receive( :can_en_passant? )
    allow( enpassant ).to receive( :capture_pawn_en_passant! )
  end

  describe "#determine_possible_moves" do
    context "when there are no diagonal enemies and no forward blockers" do
      it "has two possible move" do
        allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( true )
        allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( true )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 2 )
      end
    end

    context "when there are diagonal enemies and forward blockers" do         
      it "returns only two possible moves" do
        allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( true )
        allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( true )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 2 )
      end
      
      context "when on the edge of the board" do
        it "returns no possible moves" do 
          allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( false )
          allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( false )   
          pawn.determine_possible_moves
          expect( pawn.possible_moves.size ).to eq( 0 )
        end
      end
    end
  
    context "when there is a diagonal friendly" do
      it "returns no possible moves" do
        allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :left ).and_return( false )
        allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 0 )
      end
    end
  
    context "when there is a piece straight ahead" do
      it "returns no possible moves" do
        allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( false )
        allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 0 )
      end
    end

    context "when there is a piece two spots ahead" do
      it "returns one possible move" do
        allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( true )
        allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves.size ).to eq( 1 )
      end
    end
    
    context "when en passant" do
      it "checks to see if the pawn can perform en passant to the left" do
        expect( enpassant ).to receive( :can_en_passant? ).with( pawn, :previous )
        pawn.determine_possible_moves
      end
      
      it "checks to see if the pawn can perform en passant to the right" do
        expect( enpassant ).to receive( :can_en_passant? ).with( pawn, :next )
        pawn.determine_possible_moves
      end
      
      it "returns the possible move for en_passant" do
        expect( enpassant ).to receive( :can_en_passant? ).and_return true
        allow( enpassant ).to receive( :capture_pawn_en_passant! ).and_return( ["d", 3, "e.p."] )
        pawn.determine_possible_moves
        expect( pawn.possible_moves ).to eq( [["d", 3, "e.p."]] )
      end
    end

    it "clears possible moves when not empty" do
      pawn.possible_moves << ["a", 3]
      allow( board ).to receive( :move_straight_one_space? ).and_return( true )
      allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( true )
      pawn.determine_possible_moves
      expect( pawn.possible_moves ).to eq( [["b", 3], ["b", 4]] )
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
  
  describe "update_en_passant!" do
    it "updates the status of the pawn's en_passant" do
      pawn.update_en_passant_status!
      expect( pawn.capture_through_en_passant ).to be_false
    end
  end

  describe "#can_be_captured_en_passant?" do
    it "returns true if the pawn can be captured through en passant" do
      expect( pawn.can_be_captured_en_passant? ).to be_true
    end
    
    it "returns false if the pawn can't be captured through en passant" do
      pawn.update_en_passant_status!
      expect( pawn.can_be_captured_en_passant? ).to be_false
    end
  end

  it "finds the pawn's starting location" do
    expect( pawn.starting_location ).to eq( ["b", 2] )
  end
end