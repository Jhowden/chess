require_relative 'spec_helper'

describe UserCommands do

  let(:user_commands) { described_class.new }
  # how do I mock out gets?

  # describe "#user_input" do
  #   it "asks for a player's input" do
  #     expect( Kernel ).to receive( :gets ).and_return "white"
  #     user_commands.user_input
  #   end
  # end

  describe "#user_input" do
    it "asks for a player's input" do
      expect( user_commands ).to receive( :gets ).and_return "white"
      user_commands.user_input
    end
  end

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
      allow( STDOUT ).to receive( :puts ).with( "Please enter a correctly formated move (ex: b3 b6, 0-0 to castle kingside, or 0-0-0 to castle queenside):" )
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
  end
end