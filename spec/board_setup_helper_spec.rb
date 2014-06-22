require_relative 'spec_helper'

describe BoardSetupHelper do

  let(:board) { double() }
  let(:player) { double() }
  let(:piece) { double() }
  let(:game) { Game.new( board ).extend( described_class) }

  describe "#set_player_team" do
    it "instantiates a player object" do
      expect( game.set_player_team( "white" ) ).
        to be_an_instance_of Player
    end
  end

  describe "#create_team" do
    it "creates a team of 16 pieces" do
      expect( game.create_team( :black ).size ).to eq( 16 )
    end

    it "creates a piece with the right attribuets" do
      pawn = game.create_team( :black ).first
      expect( pawn.team ).to eq( :black )
      expect( pawn.position.file ).to eq( "a" )
      expect( pawn.position.rank ).to eq( 2 )
      expect( pawn.board_marker ).to eq( "♟" )
      expect( pawn.orientation ).to eq( :up )
    end
  end

  describe "#place_pieces_on_board" do
    it "populates the board with the player's pieces" do
      expect( board ).to receive( :place_pieces_on_board ).with player
      game.place_pieces_on_board player
    end
  end

  describe "#set_players_team_pieces" do
    it "sets the player's pieces array with the newly created pieces" do
      allow( player ).to receive( :find_king_piece )
      expect( player ).to receive( :set_team_pieces ).with [piece]
      game.set_players_team_pieces( player, [piece] )
    end

    it "find and sets the player's king piece" do
      allow( player ).to receive( :set_team_pieces ).with [piece]
      expect( player ).to receive( :find_king_piece )
      game.set_players_team_pieces( player, [piece] )
    end
  end

  describe "#set_up_players_half_of_board" do
    it "places the pieces on the board" do
      allow( player ).to receive( :set_team_pieces )
      allow( player ).to receive( :find_king_piece )
      expect( board ).to receive( :place_pieces_on_board ).with player
      game.set_up_players_half_of_board( :black, player )
    end

    it "sets the needed pieces on the player" do
      allow( board ).to receive( :place_pieces_on_board )
      expect( player ).to receive( :set_team_pieces )
      expect( player ).to receive( :find_king_piece )
      game.set_up_players_half_of_board( :black, player )
    end
  end
end