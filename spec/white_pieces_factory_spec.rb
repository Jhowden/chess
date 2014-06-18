require "spec_helper"

describe WhitePiecesFactory do

  let(:board) { double() }
  let(:white_pieces_factory) { described_class.new( board, :white ) }

  describe "#create_pawns" do
    before( :each ) do
      white_pieces_factory.create_pawns
      @first_pawn = white_pieces_factory.pieces.first
    end

    it "creates the 8 white pawns" do
      expect( white_pieces_factory.pieces.size ).to eq( 8 )
    end

    it "creates a pawn with the correct board marker" do
      expect( @first_pawn.board_marker ).to eq( "♙" )
    end

    it "creates a pawn with the correct file" do
      expect( @first_pawn.position.file ).to eq( "a" )
    end

    it "creates a pawn with the correct rank" do
      expect( @first_pawn.position.rank ).to eq( 7 )
    end

    it "creates a pawn with the correct team" do
      expect( @first_pawn.team ).to eq( :white )
    end

    it "creates a pawn with the correct board" do
      expect( @first_pawn.board ).to eq( board )
    end

    it "creates a pawn with the correct orientation" do
      expect( @first_pawn.orientation ).to eq( :down )
    end
  end

  describe "#create_rooks" do

    before( :each ) do
      white_pieces_factory.create_rooks
      @first_rook = white_pieces_factory.pieces.first
    end

    it "creates the white rooks" do
      expect( white_pieces_factory.pieces.size ).to eq( 2 )
    end

    it "creates a rook with the correct board marker" do
      expect( @first_rook.board_marker ).to eq( "♖" )
    end

    it "creates a rook with the correct file" do
      expect( @first_rook.position.file ).to eq( "a" )
    end

    it "creates a rook with the correct rank" do
      expect( @first_rook.position.rank ).to eq( 8 )
    end

    it "creates a rook with the correct team" do
      expect( @first_rook.team ).to eq( :white )
    end

    it "creates a rook with the correct board" do
      expect( @first_rook.board ).to eq( board )
    end
  end

  describe "#create_bishops" do

    before( :each ) do
      white_pieces_factory.create_bishops
      @first_bishop = white_pieces_factory.pieces.first
    end

    it "creates the white bishops" do
      expect( white_pieces_factory.pieces.size ).to eq( 2 )
    end

    it "creates a bishop with the correct board marker" do
      expect( @first_bishop.board_marker ).to eq( "♗" )
    end

    it "creates a bishop with the correct file" do
      expect( @first_bishop.position.file ).to eq( "c" )
    end

    it "creates a bishop with the correct rank" do
      expect( @first_bishop.position.rank ).to eq( 8 )
    end

    it "creates a bishop with the correct team" do
      expect( @first_bishop.team ).to eq( :white )
    end

    it "creates a bishop with the correct board" do
      expect( @first_bishop.board ).to eq( board )
    end
  end

  describe "#create_knights" do

    before( :each ) do
      white_pieces_factory.create_knights
      @first_knight = white_pieces_factory.pieces.first
    end

    it "creates the white knights" do
      expect( white_pieces_factory.pieces.size ).to eq( 2 )
    end

    it "creates a knight with the correct board marker" do
      expect( @first_knight.board_marker ).to eq( "♘" )
    end

    it "creates a knight with the correct file" do
      expect( @first_knight.position.file ).to eq( "b" )
    end

    it "creates a knight with the correct rank" do
      expect( @first_knight.position.rank ).to eq( 8 )
    end

    it "creates a knight with the correct team" do
      expect( @first_knight.team ).to eq( :white )
    end

    it "creates a knight with the correct board" do
      expect( @first_knight.board ).to eq( board )
    end
  end

  describe "#create_queen" do

    before( :each ) do
      white_pieces_factory.create_queen
      @queen = white_pieces_factory.pieces.first
    end

    it "creates the white queen" do
      expect( white_pieces_factory.pieces.size ).to eq( 1 )
    end

    it "creates a queen with the correct board marker" do
      expect( @queen.board_marker ).to eq( "♕" )
    end

    it "creates a queen with the correct file" do
      expect( @queen.position.file ).to eq( "d" )
    end

    it "creates a queen with the correct rank" do
      expect( @queen.position.rank ).to eq( 8 )
    end

    it "creates a queen with the correct team" do
      expect( @queen.team ).to eq( :white )
    end

    it "creates a queen with the correct board" do
      expect( @queen.board ).to eq( board )
    end
  end

  describe "#create_king" do

    before( :each ) do
      white_pieces_factory.create_king
      @king = white_pieces_factory.pieces.first
    end

    it "creates the white king queen" do
      expect( white_pieces_factory.pieces.size ).to eq( 1 )
    end

    it "creates a king with the correct board marker" do
      expect( @king.board_marker ).to eq( "♔" )
    end

    it "creates a king with the correct file" do
      expect( @king.position.file ).to eq( "e" )
    end

    it "creates a king with the correct rank" do
      expect( @king.position.rank ).to eq( 8 )
    end

    it "creates a king with the correct team" do
      expect( @king.team ).to eq( :white )
    end

    it "creates a king with the correct board" do
      expect( @king.board ).to eq( board )
    end
  end
  
  describe "#build" do
    it "creates all of the white team's pieces" do
      white_pieces_factory.build
      expect( white_pieces_factory.pieces.size ).to eq( 16 )
    end
  end
end