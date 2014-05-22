require "spec_helper"

describe BlackPiecesFactory do

  let(:board) { double() }
  let(:black_pieces_factory) { described_class.new( board ) }

  describe "#create_pawns" do
    it "creates the black pawns" do
      black_pieces_factory.create_pawns
      expect( black_pieces_factory.pieces.size ).to eq( 8 )
      black_pieces_factory.pieces.each do |pawn|
        expect( pawn ).to be_an_instance_of Pawn
      end
    end
  end

  describe "#create_rooks" do
    it "creates the black rooks" do
      black_pieces_factory.create_rooks
      expect( black_pieces_factory.pieces.size ).to eq( 2 )
      black_pieces_factory.pieces.each do |rook|
        expect( rook ).to be_an_instance_of Rook
      end
    end
  end

  describe "#create_bishops" do
    it "creates the black bishops" do
      black_pieces_factory.create_bishops
      expect( black_pieces_factory.pieces.size ).to eq( 2 )
      black_pieces_factory.pieces.each do |bishop|
        expect( bishop ).to be_an_instance_of Bishop
      end
    end
  end

  describe "#create_knights" do
    it "creates the black knights" do
      black_pieces_factory.create_knights
      expect( black_pieces_factory.pieces.size ).to eq( 2 )
      black_pieces_factory.pieces.each do |knight|
        expect( knight ).to be_an_instance_of Knight
      end
    end
  end

  describe "#create_queen" do
    it "creates the black queen" do
      black_pieces_factory.create_queen
      expect( black_pieces_factory.pieces.size ).to eq( 1 )
      expect( black_pieces_factory.pieces.first ).to be_an_instance_of Queen
    end
  end

  describe "#create_king" do
    it "creates the black king queen" do
      black_pieces_factory.create_king
      expect( black_pieces_factory.pieces.size ).to eq( 1 )
      expect( black_pieces_factory.pieces.first ).to be_an_instance_of King
    end
  end
  
  describe "#build" do
    it "creates all of the black team's pieces" do
      expect( black_pieces_factory ).to receive( :create_pawns )
      expect( black_pieces_factory ).to receive( :create_rooks )
      expect( black_pieces_factory ).to receive( :create_knights )
      expect( black_pieces_factory ).to receive( :create_bishops )
      expect( black_pieces_factory ).to receive( :create_queen )
      expect( black_pieces_factory ).to receive( :create_king )
      black_pieces_factory.build
    end
  end
end