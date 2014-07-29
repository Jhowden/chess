require 'spec_helper'

describe Game do

  let(:board) { stub_const( "Board", Class.new ) }
  let(:player_1) { double( team: :white, team_pieces: [piece], checkmate?: false ) }
  let(:position) { double( file: "b", rank: 3 ) }
  let(:piece) { double( team: :white ) }
  let(:piece2) { double( team: :black, captured?: false ) }
  let(:player_2) { double( team: :black, team_pieces: [piece2] ) }
  let(:user_commands) { double() }
  let(:board_view) { double() }
  let(:chess_board ) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let(:king) { double() } 
  let(:game) { described_class.new( board, user_commands, board_view ) }

  before(:each) do
    stub_const( "Checkmate", Class.new )
    stub_const( "Player", Class.new )
    stub_const( "ScreenClear", Class.new )
    allow( Checkmate ).to receive( :new ).and_return Checkmate
    allow( board ).to receive( :create_board ).and_return chess_board
    allow( board ).to receive( :find_piece ).and_return( piece )
    allow( board ).to receive( :place_pieces_on_board )
    allow( piece2 ).to receive( :respond_to? ).and_return false
    allow( ScreenClear ).to receive( :clear_screen! )
  end

  describe "#play!" do
    before( :each ) do
      allow( STDOUT ).to receive( :puts )
      allow( Player ).to receive( :set_team_pieces )
      allow( Player ).to receive( :find_king_piece )
      allow( Player ).to receive( :team ).and_return( :black, :white, :black, :white )
      allow( user_commands ).to receive( :user_team_input ).and_return( "black" )
      allow( Player ).to receive( :new ).and_return Player
      allow( Player ).to receive( :checkmate? ).and_return true, false
      allow( board_view ).to receive( :display_board )
      allow( user_commands ).to receive( :user_move_input ).and_return "a3 b4"
      allow( piece ).to receive( :increase_move_counter! )
      allow( board ).to receive( :update_board )
      allow( board ).to receive( :remove_old_position )
      allow( piece ).to receive( :update_piece_position )
      allow( king ).to receive( :check? ).and_return false
      allow( piece2 ).to receive( :determine_possible_moves ).and_return [["b", 2]]
      allow( Player ).to receive( :king_piece ).and_return king
      allow( piece ).to receive( :determine_possible_moves ).and_return [["b", 4]]
      allow( Player ).to receive( :team_pieces ).and_return [piece2]
    end

    it "sets the player's teams" do
      game.play!
      expect( game.player1.team ).to eq( :black )
      expect( game.player2.team ).to eq( :white )
    end

    it "displays who is the winner" do
      expect( STDOUT ).to receive( :puts ).with( "White team is the winner!")
      game.play!
    end

    it "asks for a player's move" do
      allow( Player ).to receive( :checkmate? ).and_return( false, false, true, false )
      expect( user_commands ).to receive( :user_move_input ).at_least( 1 ).and_return "a3 b4"
      game.play!
    end

    it "updates the piece's location" do
      allow( Player ).to receive( :checkmate? ).and_return( false, false, true, false )
      expect( piece ).to receive( :update_piece_position ).with "b", 4
      game.play!
    end

    it "updates the board after the player moves" do
      allow( Player ).to receive( :checkmate? ).and_return( false, false, true, false )
      expect( board ).to receive( :update_board ).with( piece )
      game.play!
    end

    it "removes the piece's old position" do
      allow( Player ).to receive( :checkmate? ).and_return( false, false, true, false )
      expect( board ).to receive( :remove_old_position ).with( instance_of Position )
      game.play!
    end

    it "removes the piece's old position" do
      allow( Player ).to receive( :checkmate? ).and_return( false, false, true, false )
      expect( piece ).to receive( :increase_move_counter! )
      game.play!
    end
  end

  describe "#update_the_board!" do
    before( :each ) do
      allow( board ).to receive( :update_board )
      allow( board ).to receive( :remove_old_position )
      allow( piece ).to receive( :update_piece_position )
    end
    
    it "updates the position of the piece" do
      expect( piece ).to receive( :update_piece_position ).with( "d", 3 )
      game.update_the_board!( piece, "d", 3, position )
    end

    it "updates the board" do
      expect( board ).to receive( :update_board ).with piece
      game.update_the_board!( piece, "d", 3, position )
    end

    it "removes the piece's old location from the board" do
      expect( board ).to receive( :remove_old_position ).with position
      game.update_the_board!( piece, "d", 3, position )
    end
  end

  describe "#player_in_check?" do
    before(:each) do
      allow( piece2 ).to receive( :determine_possible_moves ).and_return [["c", 3], ["c",4], ["c", 5], ["c", 6]]
      allow( king ).to receive( :check? )
      allow( player_1 ).to receive( :king_piece ).and_return king
    end

    it "returns the player's king piece" do
      expect( king ).to receive( :check? )
      game.player_in_check?( player_1, player_2 )
    end

    it "checks to see if a king piece is in check" do
      expect( king ).to receive( :check? ).with [["c", 3], ["c",4], ["c", 5], ["c", 6]]
      game.player_in_check?( player_1, player_2 )
    end
  end

  describe "#increase_piece_move_counter" do
    it "increases the pieces counter by one" do
      expect( piece ).to receive( :increase_move_counter! )
      game.increase_piece_move_counter( piece )
    end
  end
end
