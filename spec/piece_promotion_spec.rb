require 'spec_helper'

describe PiecePromotion do
  class FakeGameClass
    attr_reader :user_commands, :board
    
    def initialize
      @user_commands = UserCommands.new
      @board = Board.new
    end
  end

  let(:game) { double() }
  let(:piece_promotion) { FakeGameClass.new.extend( described_class ) }
  let(:position) { double( file: "e", rank: 1 ) }
  let(:white_pawn) { double( position: position, team: :white ) }
  let(:black_pawn) { double( team: :black) }
  let(:promoted_piece) { double() }

  before( :each ) do
    stub_const "UserCommands", Class.new
    allow( UserCommands ).to receive( :new ).and_return UserCommands

    stub_const "Board", Class.new
    allow( Board ).to receive( :new ).and_return Board

    stub_const "Queen", Class.new
    allow( Queen ).to receive( :new ).and_return Queen

    allow( black_pawn ).to receive( :position ).and_return black_pawn
  end

  describe "#pawn_can_be_promoted?" do
    context "when a pawn has moved the entire board" do
      it "returns true when a white pawn has reached rank 1" do
        allow( white_pawn ).to receive( :rank ).and_return 1

        expect( piece_promotion.pawn_can_be_promoted?( white_pawn ) ).to be
      end

      it "returns true when a black pawn has reached rank 8" do
        allow( black_pawn ).to receive( :rank ).and_return 8

        expect( piece_promotion.pawn_can_be_promoted?( black_pawn ) ).to be
      end
    end

    context "when a pawn has not moved the entire board" do
      it "returns false when a white pawn has not reached rank 1" do
        allow( position ).to receive( :rank ).and_return 3

        expect( piece_promotion.pawn_can_be_promoted?( white_pawn ) ).to_not be
      end

      it "returns false when a black pawn has not reached rank 1" do
        allow( black_pawn ).to receive( :rank ).and_return 7

        expect( piece_promotion.pawn_can_be_promoted?( black_pawn ) ).to_not be
      end
    end
  end

  describe "#replace_pawn_with_promoted_piece" do
    before( :each ) do
      allow( Board ).to receive( :update_board )
      allow( UserCommands ).to receive( :piece_promotion_input ).and_return "Queen"
    end

    it "creates the new piece" do
      allow( UserCommands ).to receive( :piece_promotion_input ).and_return "Queen"

      piece_promotion.replace_pawn_with_promoted_piece white_pawn

      expect( Queen ).to have_received( :new ).with( "e", 1, :white, Board )
    end

    it "puts the new piece on the board" do
      allow( Board ).to receive( :update_board )

      piece_promotion.replace_pawn_with_promoted_piece white_pawn

      expect( Board ).to have_received( :update_board ).with Queen
    end
  end
end