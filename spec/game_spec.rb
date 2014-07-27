require_relative 'spec_helper'

describe Game do

  let(:board) { stub_const( "Board", Class.new ) }
  let(:board2) { stub_const( "Board", Class.new ) }
  let(:player_1) { double( team: :white, team_pieces: [piece], checkmate?: false ) }
  let(:position) { double( file: "b", rank: 3 ) }
  let(:piece) { double( team: :white ) }
  let(:piece2) { double( team: :black, captured?: false ) }
  let(:player_2) { double( team: :black, team_pieces: [piece2] ) }
  let(:players_pieces) { [piece] * 16 }
  let(:user_commands) { double() }
  let(:board_view) { double() }
  let(:chess_board ) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let(:null_piece) { stub_const( "NullPiece", Class.new ) }
  let(:king) { double() } 
  let(:game) { described_class.new( board, user_commands, board_view ) }

  before(:each) do
    stub_const( "Checkmate", Class.new )
    stub_const( "Player", Class.new )
    allow( Checkmate ).to receive( :new ).and_return Checkmate
    allow( board ).to receive( :create_board ).and_return chess_board
    allow( board ).to receive( :find_piece ).and_return( piece )
    allow( board ).to receive( :place_pieces_on_board )
    allow( piece ).to receive( :determine_possible_moves ).and_return ( [["a", 2]] )
    allow( piece2 ).to receive( :determine_possible_moves ).and_return ( [["e", 7]] )
    allow( board ).to receive( :find_piece_on_board ).and_return piece2
    allow( piece2 ).to receive( :respond_to? ).and_return false
  end

  describe "#play!" do
    it "sets the player's teams" do
      allow( STDOUT ).to receive( :puts )
      allow( Player ).to receive( :set_team_pieces )
      allow( Player ).to receive( :find_king_piece )
      allow( Player ).to receive( :team ).and_return( :black, :white, :black, :white )
      allow( user_commands ).to receive( :user_team_input ).and_return( "black" )
      allow( Player ).to receive( :new ).and_return Player
      allow( Player ).to receive( :checkmate? ).and_return true, false
      allow( board_view ).to receive( :display_board )
      game.play!
      expect( game.player1.team ).to eq( :black )
      expect( game.player2.team ).to eq( :white )
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

  # describe "#move_piece" do
  #   before(:each) do
  #     allow( piece ).to receive( :update_piece_position )
  #     allow( board ).to receive( :update_board )
  #     allow( board ).to receive( :remove_old_position )
  #     allow( player_1 ).to receive( :king_piece ).and_return king
  #     allow( king ).to receive( :check? ).and_return false
  #     allow( position ).to receive( :dup ).and_return position
  #     allow( user_commands ).to receive( :user_move_input ).and_return "b3 a3"
  #     allow( piece ).to receive( :determine_possible_moves ).and_return( [["a", 3]] )
  #   end

  #   context "when piece and player are on the same team" do
  #     context "when it is a legal move" do
  #       it "updates the pieces position" do
  #         expect( piece ).to receive( :update_piece_position ).with( "a", 3 )
  #         game.move_piece( piece, player_1, player_2, "a", 3, position )
  #       end

  #       it "updates the pieces location on the board" do
  #         expect( board ).to receive( :update_board ).with( piece )
  #         game.move_piece( piece, player_1, player_2, "a", 3, position )
  #       end

  #       it "updates the pieces location on the board" do
  #         expect( board ).to receive( :remove_old_position ).with position
  #         game.move_piece( piece, player_1, player_2, "a", 3, position )
  #       end
  #     end

  #     context "when it is an illegal move" do
  #       it "starts the start_player_move again" do
  #         allow( STDOUT ).to receive( :puts )
  #         expect( king ).to receive( :check? ).and_return false
  #         game.move_piece( piece, player_1, player_2, "a", 2, position )
  #       end
  #     end
  #   end

  #   context "when piece and player are not the same team" do
  #     it "starts the #start_player_move again" do
  #       allow( piece ).to receive( :team ).and_return( :black, :white)
  #       allow( STDOUT ).to receive( :puts )
  #       expect( king ).to receive( :check? ).and_return false
  #       game.move_piece( piece, player_1, player_2, "a", 2, position )
  #     end
  #   end

  #   context "when a piece's move puts own king in check" do
  #     before(:each) do
  #       allow( STDOUT ).to receive( :puts )
  #       allow( player_2 ).to receive( :team_pieces ).and_return [piece2]
  #       allow( piece2 ).to receive( :determine_possible_moves ).and_return ["b", 1]
  #       allow( player_1 ).to receive( :king_piece ).and_return king
  #       allow( king ).to receive( :check? ).and_return true
  #     end

  #     it "returns the piece back to its original position" do
  #       expect( piece ).to receive( :update_piece_position ).with( "b", 3)
  #       game.move_piece( piece, player_1, player_2, "a", 3, position )
  #     end 

  #     it "does nothing when no piece was captured" do
  #       expect( piece2 ).to_not receive( :captured! )
  #       game.move_piece( piece, player_1, player_2, "a", 3, position )
  #     end

  #     it "restores a captured piece back to its original position" do
  #       allow( piece2 ).to receive( :respond_to? ).and_return true
  #       allow( piece2 ).to receive( :captured! )
  #       expect( board ).to receive( :update_board ).with piece2
  #       game.move_piece( piece, player_1, player_2, "a", 3, position )
  #     end
  #   end
  # end

  # describe "#start_player_move" do
  #   before(:each) do
  #     allow( player_1 ).to receive( :king_piece ).and_return king
  #     allow( king ).to receive( :check? ).and_return false
  #     allow( STDOUT ).to receive( :puts )
  #     allow( board ).to receive( :update_board ).with( piece )
  #     allow( board ).to receive( :remove_old_position )
  #   end

  #   context "when king not in check" do
  #     before(:each) do
  #       allow( user_commands ).to receive( :user_move_input ).and_return "a1 a2"
  #       allow( piece ).to receive( :update_piece_position ).with( "a", 2 )
  #     end

  #     it "retrieves the player's input" do
  #       expect( user_commands ).to receive( :user_move_input ).and_return "a1 a2"
  #       game.start_player_move( player_1, player_2 )
  #     end

  #     it "updates the selected piece's position" do
  #       expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
  #       game.start_player_move( player_1, player_2 )
  #     end

  #     it "updates the piece's location on the board" do
  #       expect( board ).to receive( :update_board ).with( piece )
  #       game.start_player_move( player_1, player_2 )
  #     end

  #     it "removes the piece's old location from the board" do
  #       expect( board ).to receive( :remove_old_position )
  #       game.start_player_move( player_1, player_2 )
  #     end
  #   end

  #   context "when piece returns a NullObject" do
  #     it "goes through start_player_move twice and updates piece position" do
  #       allow( user_commands ).to receive( :user_move_input ).and_return("a1 c2", "a1 a2")
  #       allow( board ).to receive( :find_piece ).and_return( null_piece, piece )
  #       allow( null_piece ).to receive( :team ).and_return false
  #       expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
  #       game.start_player_move( player_1, player_2 )
  #     end
  #   end
    
  #   context "when king is in check" do
  #     before(:each) do
  #       allow( player_1 ).to receive( :king_piece ).and_return king
  #       allow( king ).to receive( :check? ).and_return true
  #       allow( Checkmate ).to receive( :find_checkmate_escape_moves ).and_return ["a1a2"]
  #       allow( user_commands ).to receive( :user_move_input ).and_return "a1 a2"
  #       allow( piece ).to receive( :update_piece_position )
  #       allow( board ).to receive( :update_board ).with( piece )
  #       allow( board ).to receive( :remove_old_position )
  #     end
      
  #     it "asks for a list of possible moves" do
  #       expect( Checkmate ).to receive( :find_checkmate_escape_moves ).with( player_1, player_2 )
  #       game.start_player_move( player_1, player_2 )
  #     end
      
  #     it "updates the players checkmate status to true if no moves are returned" do
  #       allow( Checkmate ).to receive( :find_checkmate_escape_moves ).and_return []
  #       allow( player_1 ).to receive( :checkmate? ).and_return true 
  #       expect( player_1 ).to receive( :checkmate! )
  #       game.start_player_move( player_1, player_2 )
  #     end
      
  #     it "retrieves the player's input" do
  #       expect( user_commands ).to receive( :user_move_input ).and_return "a1 a2"
  #       game.start_player_move( player_1, player_2 )
  #     end
      
  #     it "checks to see if the user input is valid move out of checkmate" do
  #       expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
  #       game.start_player_move( player_1, player_2 )
  #     end
      
  #     it "starts the sequence again if the user does not select a valid move out of checkmate" do
  #       allow( user_commands ).to receive( :user_move_input ).and_return( "a2 a3", "a1 a2" )
  #       expect( piece ).to receive( :update_piece_position ).with( "a", 2 )
  #       game.start_player_move( player_1, player_2 )
  #     end
  #   end
  # end
end