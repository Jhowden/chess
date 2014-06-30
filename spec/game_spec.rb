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
  let(:board_view) { double() }
  let(:chess_board ) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let(:null_piece) { stub_const( "NullPiece", Class.new ) }
  let(:game) { described_class.new( board, user_commands, board_view ) }

  before(:each) do
    allow( board ).to receive( :create_board ).and_return chess_board
    allow( board ).to receive( :find_piece ).and_return( piece )
    allow( board ).to receive( :place_pieces_on_board )
    allow( piece ).to receive( :determine_possible_moves ).and_return ( [["a", 2]] )
    allow( piece2 ).to receive( :determine_possible_moves ).and_return ( [["e", 7]] )
  end

  describe "#get_player_teams" do
    it "sets the player 2's team to white when player 1 is black" do
      allow( STDOUT ).to receive( :puts ).
        with( "Please choose your team player 1 (white or black):" )
      allow( STDOUT ).to receive( :puts ).
        with( "Player 2's team has been set to white" )
      allow( user_commands ).to receive( :user_team_input ).and_return( "black" )
      game.get_player_teams
      expect( game.player1.team ).to eq( :black )
      expect( game.player2.team ).to eq( :white )
    end

    it "sets the player 2's team to black when player 1 is white" do
      allow( STDOUT ).to receive( :puts ).
        with( "Please choose your team player 1 (white or black):" )
      allow( STDOUT ).to receive( :puts ).
        with( "Player 2's team has been set to black" )
      allow( user_commands ).to receive( :user_team_input ).and_return( "white" )
      game.get_player_teams
      expect( game.player1.team ).to eq( :white )
      expect( game.player2.team ).to eq( :black )
    end
  end

  describe "#get_player_move" do
    it "selects a piece and moves it to a new location" do
      allow( STDOUT ).to receive( :puts ).
        with( "Please select a piece you would like to move and its new position (ex: b3 b6):" )
      expect( user_commands ).to receive( :user_move_input ).once
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

  describe "#update_the_board!" do
    before(:each) do
      allow( piece ).to receive( :update_piece_position )
      allow( board ).to receive( :update_board )
      allow( board ).to receive( :remove_old_position )
    end

    it "updates the pieces position" do
      expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
      game.update_the_board!( piece, "a", 2, position )
    end

    it "updates the piece location on the board" do
      expect( board ).to receive( :update_board ).with piece
      game.update_the_board!( piece, "a", 2, position )
    end

    it "removes the piece's old location from the board" do
      expect( board ).to receive( :remove_old_position ).with position
      game.update_the_board!( piece, "a", 2, position )
    end
  end

  describe "#move_piece" do
    before(:each) do
      allow( piece ).to receive( :update_piece_position )
      allow( board ).to receive( :update_board )
      allow( board ).to receive( :remove_old_position )
      allow( player_1 ).to receive( :king_piece ).and_return player_1
      allow( user_commands ).to receive( :user_move_input ).and_return "b3 a3"
      allow( piece ).to receive( :determine_possible_moves ).and_return( [["a", 3]] )
    end

    context "when piece and player are on the same team" do
      context "when it is a legal move" do
        it "updates the pieces position" do
          expect( piece ).to receive( :update_piece_position ).with( "a", 3 )
          game.move_piece( piece, player_1, player_2, "a", 3, position )
        end

        it "updates the pieces location on the board" do
          expect( board ).to receive( :update_board ).with piece
          game.move_piece( piece, player_1, player_2, "a", 3, position )
        end

        it "updates the pieces location on the board" do
          expect( board ).to receive( :remove_old_position ).with position
          game.move_piece( piece, player_1, player_2, "a", 3, position )
        end
      end

      context "when it is an illegal move" do
        it "starts the start_player_move again" do
          allow( STDOUT ).to receive( :puts )
          expect( player_1 ).to receive( :check? ).and_return false
            game.move_piece( piece, player_1, player_2, "a", 2, position )
        end
      end
    end

    context "when piece and player are not the same team" do
      it "starts the pstart_player_move again" do
        allow( piece ).to receive( :team ).and_return( :black, :white)
        allow( STDOUT ).to receive( :puts )
        expect( player_1 ).to receive( :check? ).and_return false
        game.move_piece( piece, player_1, player_2, "a", 2, position )
      end
    end
  end

  describe "#start_player_move" do
    before(:each) do
      allow( player_1 ).to receive( :king_piece ).and_return piece
      allow( piece ).to receive( :check? ).and_return false
      allow( STDOUT ).to receive( :puts )
      allow( board ).to receive( :update_board ).with( piece )
      allow( board ).to receive( :remove_old_position )
    end

    context "when king not in check" do
      before(:each) do
        allow( user_commands ).to receive( :user_move_input ).and_return "a1 a2"
        allow( piece ).to receive( :update_piece_position ).with( "a", 2 )
      end

      it "retrieves the player's input" do
        expect( user_commands ).to receive( :user_move_input ).and_return "a1 a2"
        game.start_player_move( player_1, player_2 )
      end

      it "updates the selected piece's position" do
        expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
        game.start_player_move( player_1, player_2 )
      end

      it "updates the piece's location on the board" do
        expect( board ).to receive( :update_board ).with( piece )
        game.start_player_move( player_1, player_2 )
      end

      it "removes the piece's old location from the board" do
        expect( board ).to receive( :remove_old_position )
        game.start_player_move( player_1, player_2 )
      end
    end

    context "when piece returns a NullObject" do
      it "goes through start_player_move twice and updates piece position" do
        allow( user_commands ).to receive( :user_move_input ).and_return("a1 c2", "a1 a2")
        allow( board ).to receive( :find_piece ).and_return( null_piece, piece )
        allow( null_piece ).to receive( :team ).and_return false
        expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
        game.start_player_move( player_1, player_2 )
      end
    end
  end
  
  describe "#display_board" do
    it "displays the board" do
      expect( board_view ).to receive( :display_board )
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
      allow( player_2 ).to receive( :team_pieces ).and_return players_pieces
      allow( players_pieces ).to receive( :map ).and_yield piece
      allow( piece ).to receive( :captured? ).and_return false
      allow( piece ).to receive( :determine_possible_moves ).and_return [[["a", 3], ["b",4]], [["c",5], ["c", 4], ["c",3]]]
      allow( player_1 ).to receive( :king_piece ).and_return( player_1 )
      expect( player_1 ).to receive( :check? ).with [["a", 3],["b",4],["c",5], ["c", 4],["c",3]]
      game.player_in_check?( player_1, player_2 )
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