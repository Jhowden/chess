require_relative 'spec_helper'

describe Game do

  let(:game) { described_class.new( board ) }
  let(:board) { stub_const( "Board", Class.new ) }
  let(:player_1) { double( team: :white ) }
  let(:position) { double( file: "b", rank: 3 ) }
  let(:piece) { double( team: :white ) }

  before(:each) do
    allow( board ).to receive( :populate_white_team )
    allow( board ).to receive( :create_board ).and_return Array.new( 8 ) { |cell| Array.new( 8 ) }
    allow( game ).to receive( :puts )
    allow( game ).to receive( :print )
    allow( game ).to receive( :gets ).and_return( game )
    allow( game ).to receive( :chomp )
    allow( board ).to receive( :find_piece ).and_return( piece )
    allow( piece ).to receive( :determine_possible_moves ).and_return ( [["b", 5], ["b", 6], ["b", 7], ["b", 8]] )
    allow( piece ).to receive( :update_piece_position ).with( "b", 6 )
  end

  describe "#user_input" do
    it "asks for a player's input" do
      expect( game ).to receive( :gets ).and_return( game ).exactly( 1 ).times
      game.user_input
    end
  end

  describe "#get_player_teams" do
    it "gets the player's teams" do
      expect( game ).to receive( :gets ).exactly( 2 ).times.and_return( "white", "black" )
      game.get_player_teams
      expect( game.player1.team ).to eq( :white )
      expect( game.player2.team ).to eq( :black )
    end
  end

  describe "#get_player_move" do
    it "selects a piece and moves it to a new location" do
      expect( game ).to receive( :user_input ).exactly( 1 ).times
      game.get_player_move
    end
  end

  describe "#player_and_piece_same_team?" do
    it "checks the board to find the piece" do
      expect( board ).to receive( :find_piece ).and_return( piece )
      game.player_and_piece_same_team?( position, player_1 )
    end

    it "checks to see if the piece and player have the same team" do
      expect( game.player_and_piece_same_team?( position, player_1 ) ).to be_true
    end
  end

  describe "#check_move" do
    it "checks to see if the piece can make the move" do
      expect( game.check_move( piece, ["b", 6] ) ).to be_true
    end
  end

  describe "#update_position" do
    it "updates the piece's position" do
      expect( piece ).to receive( :update_piece_position ).with( "b", 6 )
      game.update_position( position, "b", 6 )
    end
  end

  describe "#player_turn_commands" do
    it "goes through the commands for a player to complete a turn" do
      expect( game ).to receive( :get_player_move ).and_return( "b3 b6" )
      expect( game ).to receive( :player_and_piece_same_team? ).with( an_instance_of( Position ), player_1 ).and_return( true )
      expect( game ).to receive( :check_move ).with( an_instance_of( Position ), ["b", 6] ).and_return( true )
      expect( game ).to receive( :remove_piece_marker ).with( an_instance_of( Position ) )
      expect( game ).to receive( :update_position ).with( an_instance_of( Position ), "b", 6 )
      expect( game ).to receive( :update_piece_on_board ).with( an_instance_of( Position ) )
      game.player_turn_commands( player_1 )
    end
  end
  
  describe "#display_board" do
    it "displays the board" do
      expect( game.board_interface ).to receive( :display_board )
      game.display_board
    end
  end

  describe "#update_piece_on_board" do
    it "updates the piece position on the board" do
      expect( game ).to receive( :find_piece_on_board ).with( position ).and_return( piece )
      expect( board ).to receive( :update_board ).with( piece )
      game.update_piece_on_board( position )
    end
  end
  
  describe "#remove_piece_marker" do
    it "removes a piece's marker from the board" do
      expect( board ).to receive( :remove_marker ).with( position )
      game.remove_piece_marker( position )
    end
  end
  
  # describe "#play!" do
  #   it "plays the game" do
  #     expect( game ).to receive( :player_turn_commands ).exactly( 2 ).times
  #     game.play!
  #   end
  # end
end