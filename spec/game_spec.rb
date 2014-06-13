require_relative 'spec_helper'

describe Game do

  let(:game) { described_class.new( board ) }
  let(:board) { stub_const( "Board", Class.new ) }
  let(:board2) { stub_const( "Board", Class.new ) }
  let(:player_1) { double( team: :white ) }
  let(:position) { double( file: "b", rank: 3 ) }
  let(:piece) { double( team: :white ) }
  let(:player_2) { double( team: :black ) }
  let(:players_pieces) do
    [piece] * 16
  end

  before(:each) do
    allow( board ).to receive( :create_board ).and_return Array.new( 8 ) { |cell| Array.new( 8 ) }
    # Mocking or stubbing the thing you are testing is FORBIDDEN!
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
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( game ).to receive( :gets ).exactly( 2 ).times.and_return( "white", "black" )
      expect( game ).to receive( :set_up_players_half_of_board ).with( "white", instance_of( Player ) )
      expect( game ).to receive( :set_up_players_half_of_board ).with( "black", instance_of( Player ) )
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
    it "checks to see if the piece and player have the same team" do
      expect( game.player_and_piece_same_team?( piece, player_1 ) ).to be_true
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
      game.update_position( piece, "b", 6 )
    end
  end

  describe "#player_turn_commands" do
    it "goes through the commands for a player to complete a turn" do
      expect( game ).to receive( :get_player_move ).and_return( "b3 b6" )
      expect( game ).to receive( :find_piece_on_board ).with( an_instance_of( Position ) ).and_return( piece )
      expect( game ).to receive( :player_and_piece_same_team? ).with( piece, player_1 ).and_return( true )
      expect( game ).to receive( :check_move ).with( piece, ["b", 6] ).and_return( true )
      expect( game ).to receive( :remove_piece_marker ).with( an_instance_of( Position ) )
      expect( game ).to receive( :update_position ).with( piece, "b", 6 )
      expect( game ).to receive( :update_piece_on_board ).with( piece )
      expect( game ).to receive( :display_king_in_check_message ).with( player_1, player_2 )
      game.player_turn_commands( player_1, player_2 )
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
      expect( board ).to receive( :update_board ).with( piece )
      game.update_piece_on_board( piece )
    end
  end
  
  describe "#remove_piece_marker" do
    it "removes a piece's marker from the board" do
      expect( board ).to receive( :remove_marker ).with( position )
      game.remove_piece_marker( position )
    end
  end
  
  describe "#player_in_check?" do
    it "checks to see if a player is in check" do
      expect( player_2 ).to receive( :team_pieces ).and_return players_pieces
      expect( players_pieces ).to receive( :map ).and_yield piece
      expect( piece ).to receive( :piece_captured? ).and_return false
      expect( piece ).to receive( :determine_possible_moves ).and_return [[["a", 3], ["b",4]], [["c",5], ["c", 4], ["c",3]]]
      expect( player_1 ).to receive( :king_piece ).and_return( player_1 )
      expect( player_1 ).to receive( :check? ).with [["a", 3],["b",4],["c",5], ["c", 4],["c",3]]
      game.player_in_check?( player_1, player_2 )
    end
  end
  
  describe "#display_king_in_check_message" do
    it "displays a message to inform player he is in check" do
      expect( game ).to receive( :player_in_check? ).with( player_1, player_2 ).and_return true
      expect( game ).to receive( :puts )
      game.display_king_in_check_message( player_1, player_2 )
    end
  end
  
  describe "#replace_board" do
    it "replaces the piece's board" do
      expect( game.board ).to eq( board )
      game.replace_board( board2 )
      expect( game.board ).to eq( board2 )
    end
  end
end