require_relative 'spec_helper'

describe Game do

  let(:board) { stub_const( "Board", Class.new ) }
  let(:board2) { stub_const( "Board", Class.new ) }
  let(:player_1) { double( team: :white, team_pieces: [piece] ) }
  let(:position) { double( file: "b", rank: 3 ) }
  let(:piece) { double( team: :white ) }
  let(:piece2) { double( team: :black, captured?: false ) }
  let(:player_2) { double( team: :black, team_pieces: [piece2] ) }
  let(:players_pieces) { [piece] * 16 }
  let(:user_commands) { double() }
  let(:game) { described_class.new( board, user_commands ) }
  let(:chess_board ) { Array.new( 8 ) { |cell| Array.new( 8 ) } }

  before(:each) do
    allow( board ).to receive( :create_board ).and_return chess_board
    allow( board ).to receive( :find_piece ).and_return( piece )
    allow( board ).to receive( :place_pieces_on_board )
    allow( piece ).to receive( :determine_possible_moves ).and_return ( [["a", 2]] )
    allow( piece2 ).to receive( :determine_possible_moves ).and_return ( [["e", 7]] )
  end

  describe "#get_player_teams" do
    it "gets the player's teams" do
      allow( STDOUT ).to receive( :puts ).
        with( "Please choose your team player 1 (white or black):" )
      allow( STDOUT ).to receive( :puts ).
        with( "Please choose your team player 2 (white or black):" )
      expect( user_commands ).to receive( :user_input).twice.and_return( "white", "black")
      game.get_player_teams
    end

    it "sets the player's teams" do
      allow( STDOUT ).to receive( :puts ).
        with( "Please choose your team player 1 (white or black):" )
      allow( STDOUT ).to receive( :puts ).
        with( "Please choose your team player 2 (white or black):" )
      allow( user_commands ).to receive( :user_input).twice.and_return( "white", "black")
      game.get_player_teams
      expect( game.player1.team ).to eq( :white )
      expect( game.player2.team ).to eq( :black )
    end
  end

  describe "#get_player_move" do
    it "selects a piece and moves it to a new location" do
      allow( STDOUT ).to receive( :puts ).
        with( "Please select a piece you would like to move and its new position (ex: b3 b6):" )
      expect( user_commands ).to receive( :user_input ).once
      game.get_player_move
    end
  end

  describe "#player_and_piece_same_team?" do
    it "checks to see if the piece and player have the same team" do
      expect( game.player_and_piece_same_team?( piece, player_1 ) ).to be_true
    end
  end

  describe "#check_move?" do
    it "checks to see if the piece can make the move" do
      expect( game.check_move?( piece, ["a", 2] ) ).to be_true
    end
  end

  describe "#update_position" do
    it "updates the piece's position" do
      expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
      game.update_position( piece, "a", 2 )
    end
  end

  describe "#player_turn_commands" do
    context "when king not in check" do
      before(:each) do
        allow( player_1 ).to receive( :king_piece ).and_return piece
        allow( user_commands ).to receive( :user_input ).and_return "a1 a2"
        allow( piece ).to receive( :update_piece_position ).with( "a", 2 )
        allow( board ).to receive( :update_board ).with( piece )
        allow( board ).to receive( :remove_old_position )
        allow( piece ).to receive( :check? ).and_return false
        allow( STDOUT ).to receive( :puts ).
          with( "Please select a piece you would like to move and its new position (ex: b3 b6):" )
        chess_board[0][0] = piece
        chess_board[7][7] = piece2
      end

      it "retrieves the player's input" do
        expect( user_commands ).to receive( :user_input ).and_return "a1 a2"
        game.player_turn_commands( player_1, player_2 )
      end

      it "updates the selected piece's position" do
        expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
        game.player_turn_commands( player_1, player_2 )
      end

      it "updates the piece's location on the board" do
        expect( board ).to receive( :update_board ).with( piece )
        game.player_turn_commands( player_1, player_2 )
      end

      it "removes the piece's old location from the board" do
        expect( board ).to receive( :remove_old_position )
        game.player_turn_commands( player_1, player_2 )
      end
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
  
  describe "#player_in_check?" do
    it "checks to see if a player is in check" do
      expect( player_2 ).to receive( :team_pieces ).and_return players_pieces
      expect( players_pieces ).to receive( :map ).and_yield piece
      expect( piece ).to receive( :captured? ).and_return false
      expect( piece ).to receive( :determine_possible_moves ).and_return [[["a", 3], ["b",4]], [["c",5], ["c", 4], ["c",3]]]
      expect( player_1 ).to receive( :king_piece ).and_return( player_1 )
      expect( player_1 ).to receive( :check? ).with [["a", 3],["b",4],["c",5], ["c", 4],["c",3]]
      game.player_in_check?( player_1, player_2 )
    end
  end
  
  describe "#display_king_in_check_message" do
    it "displays a message to inform player he is in check" do
      allow( player_1 ).to receive( :king_piece ).and_return piece
      allow( piece ).to receive( :check? ).and_return true
      expect( STDOUT ).to receive( :puts ).with( "Your king is in check!" )
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