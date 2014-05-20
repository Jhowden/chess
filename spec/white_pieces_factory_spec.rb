require "spec_helper"

describe WhitePiecesFactory do

  let(:board) { double() }
  let(:white_pieces_factory) { described_class.new( board ) }

  describe "#create_pawns" do
    it "creates the white pawns" do
      white_pieces_factory.create_pawns
      expect( white_pieces_factory.pieces.size ).to eq( 8 )
      white_pieces_factory.pieces.each do |pawn|
        expect( pawn ).to be_an_instance_of Pawn
      end
    end
  end

  describe "#create_rooks" do
    it "creates the white rooks" do
      white_pieces_factory.create_rooks
      expect( white_pieces_factory.pieces.size ).to eq( 2 )
      white_pieces_factory.pieces.each do |rook|
        expect( rook ).to be_an_instance_of Rook
      end
    end
  end

  describe "#create_bishops" do
    it "creates the white bishops" do
      white_pieces_factory.create_bishops
      expect( white_pieces_factory.pieces.size ).to eq( 2 )
      white_pieces_factory.pieces.each do |bishop|
        expect( bishop ).to be_an_instance_of Bishop
      end
    end
  end

  describe "#create_knights" do
    it "creates the white knights" do
      white_pieces_factory.create_knights
      expect( white_pieces_factory.pieces.size ).to eq( 2 )
      white_pieces_factory.pieces.each do |knight|
        expect( knight ).to be_an_instance_of Knight
      end
    end
  end

  describe "#create_queen" do
    it "creates the white queen" do
      white_pieces_factory.create_queen
      expect( white_pieces_factory.pieces.size ).to eq( 1 )
      expect( white_pieces_factory.pieces.first ).to be_an_instance_of Queen
    end
  end

  describe "#create_king" do
    it "creates the white king queen" do
      white_pieces_factory.create_king
      expect( white_pieces_factory.pieces.size ).to eq( 1 )
      expect( white_pieces_factory.pieces.first ).to be_an_instance_of King
    end
  end
  
  describe "#build" do
    it "creates all of the white team's pieces" do
      expect( white_pieces_factory ).to receive( :create_pawns )
      expect( white_pieces_factory ).to receive( :create_rooks )
      expect( white_pieces_factory ).to receive( :create_knights )
      expect( white_pieces_factory ).to receive( :create_bishops )
      expect( white_pieces_factory ).to receive( :create_queen )
      expect( white_pieces_factory ).to receive( :create_king )
      white_pieces_factory.build
    end
  end
end