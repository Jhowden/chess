require 'spec_helper'

describe UserCommands do

  let(:user_commands) { described_class.new }

  describe "#user_team_input" do
    it "checks to see if a player puts in the correct team color" do
      allow( user_commands ).to receive( :gets ).and_return "white"
      expect( user_commands.user_team_input ).to eq( "white" )
    end

    it "checks to see if a player puts in the correct team color" do
      allow( user_commands ).to receive( :gets ).and_return "Black"
      expect( user_commands.user_team_input ).to eq( "black" )
    end

    it "asks the player to input a correct color" do
      allow( user_commands ).to receive( :gets ).and_return( "green", "white" )
      allow( STDOUT ).to receive( :puts ).with( "That is not a valid color. Please choose again (white or black):" )
      expect( user_commands.user_team_input ).to eq( "white" )
    end
  end

  describe "#user_move_input" do
    it "asks the player to input move in the correct format" do
      allow( user_commands ).to receive( :gets ).and_return( "a33 b5", "a3 b5" )
      allow( STDOUT ).to receive( :puts ).
        with( "Please enter a correctly formatted move (ex: b3 b6, 0-0 to castle kingside, 0-0-0 to castle queenside), or b4 c3 e.p. to perform en_passant:" )
      expect( user_commands.user_move_input ).to eq( "a3 b5" )
    end

    it "accepts an input that is in the correct format" do
      allow( user_commands ).to receive( :gets ).and_return "a3 b5"
      expect( user_commands.user_move_input ).to eq( "a3 b5" )
    end

    it "accepts kingside castling as a correct format" do
      allow( user_commands ).to receive( :gets ).and_return "0-0"
      expect( user_commands.user_move_input ).to eq( "0-0" )
    end

    it "accepts queenside castling as a correct format" do
      allow( user_commands ).to receive( :gets ).and_return "0-0-0"
      expect( user_commands.user_move_input ).to eq( "0-0-0" )
    end

    it "rejects improperly cofigured castle input" do
      allow( STDOUT ).to receive( :puts )
      allow( user_commands ).to receive( :gets ).and_return( "0-0-1", "0-1", "0-0-0" )
      expect( user_commands.user_move_input ).to eq( "0-0-0" )
    end
    
    it "accepts en_passant as correct format" do
      allow( user_commands ).to receive( :gets ).and_return "b4 c3 e.p."
      expect( user_commands.user_move_input ).to eq "b4 c3 e.p."
    end
  end

  describe "#piece_promotion_input" do
    it "accepts queen as a valid piece replacement" do
      allow( user_commands ).to receive( :gets ).and_return "Queen"
      expect( user_commands.piece_promotion_input ).to eq "Queen"
    end

    it "accepts knight as a valid piece replacement" do
      allow( user_commands ).to receive( :gets ).and_return "knight"
      expect( user_commands.piece_promotion_input ).to eq "Knight"
    end

    it "accepts rook as a valid piece replacement" do
      allow( user_commands ).to receive( :gets ).and_return "Rook"
      expect( user_commands.piece_promotion_input ).to eq "Rook"
    end

    it "accepts bishop as a valid piece replacement" do
      allow( user_commands ).to receive( :gets ).and_return "bishop"
      expect( user_commands.piece_promotion_input ).to eq "Bishop"
    end

    it "doesn't accept an invalid piece replacement input" do
      allow( STDOUT ).to receive( :puts )
      allow( user_commands ).to receive( :gets ).and_return( "pawn", "bishop" )
      expect( user_commands.piece_promotion_input ).to eq "Bishop"
    end
  end
end