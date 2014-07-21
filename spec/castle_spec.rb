require "spec_helper"

describe Castle do

  let(:game) { double() }
  let(:king) { double( position: position ) }
  let(:rook) { double( position: position ) }
  let(:piece) { double() }
  let(:position) { double() }
  let(:copied_position) { double() }
  let(:player) { double() }
  let(:enemy_player) { double() }
  let(:castle) {described_class.new( game ) }

  describe "#castle_queenside" do
    before(:each) do
      allow( STDOUT ).to receive( :puts )
      allow( game ).to receive( :find_piece_on_board ).and_return( rook, piece )
      allow( position ).to receive( :dup ).and_return copied_position
      allow( game ).to receive( :update_the_board! )
      allow( game ).to receive( :player_in_check? )
      allow( game ).to receive( :increase_piece_move_counter )
      allow( game ).to receive( :start_player_move )
      allow( game ).to receive( :restore_piece_to_original_position )
      allow( king ).to receive( :move_counter ).and_return 0
      allow( rook ).to receive( :move_counter ).and_return 0
    end

    it "expect the the board to be updated" do
      expect( game ).to receive( :update_the_board! ).with( king, "d", 8, copied_position)
      castle.castle_queenside( king, 8, player, enemy_player )
    end

    it "checks to see if king is in check" do
      expect( game ).to receive( :player_in_check? ).with( player, enemy_player )
      castle.castle_queenside( king, 8, player, enemy_player )
    end

    context "when the first move puts the king in check" do
      it "restores the board" do
        allow( game ).to receive( :player_in_check? ).and_return true
        expect( game ).to receive( :restore_piece_to_original_position ).
          with( king, copied_position, copied_position )
        castle.castle_queenside( king, 8, player, enemy_player )  
      end

      it "starts the player's move over again" do
        allow( game ).to receive( :player_in_check? ).and_return true
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_queenside( king, 8, player, enemy_player ) 
      end
    end

    context "when the space is occupied" do
      it "starts the player's move over again" do
        allow( piece ).to receive( :respond_to? ).and_return true
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_queenside( king, 8, player, enemy_player ) 
      end
    end

    it "places the king in the right position" do
      allow( game ).to receive( :player_in_check? ).and_return false
      expect( game ).to receive( :update_the_board! ).with( king, "c", 8, copied_position )
      castle.castle_queenside( king, 8, player, enemy_player ) 
    end

    context "when the second move puts the king in check" do
      it "restores the board" do
        allow( game ).to receive( :player_in_check? ).and_return( false, true )
        expect( game ).to receive( :restore_piece_to_original_position ).
          with( king, copied_position, copied_position )
        castle.castle_queenside( king, 8, player, enemy_player ) 
      end

      it "starts the player's move over again" do
        allow( game ).to receive( :player_in_check? ).and_return( false, true )
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_queenside( king, 8, player, enemy_player ) 
      end
    end

    context "when the king isn't in check when castling" do
      it "places the rook in the corret position" do
        allow( game ).to receive( :player_in_check? ).and_return( false, false )
        expect( game ).to receive( :update_the_board! ).with( rook, "d", 8, copied_position )
        castle.castle_queenside( king, 8, player, enemy_player ) 
      end

      it "updates the move counter on the king" do
        allow( game ).to receive( :player_in_check? ).and_return( false, false )
        expect( game ).to receive( :increase_piece_move_counter ).with( king )
        castle.castle_queenside( king, 8, player, enemy_player )
      end

      it "updates the move counter on the rook" do
        allow( game ).to receive( :player_in_check? ).and_return( false, false )
        expect( game ).to receive( :increase_piece_move_counter ).with( rook )
        castle.castle_queenside( king, 8, player, enemy_player )
      end
    end

    context "when the king has already moved" do
      it "starts the player's move over again" do
        allow( king ).to receive( :move_counter ).and_return 1
        allow( rook ).to receive( :move_counter ).and_return 0
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_queenside( king, 8, player, enemy_player )
      end
    end
  end

  describe "#castle_kingside" do
    before(:each) do
      allow( game ).to receive( :update_the_board! )
      allow( game ).to receive( :find_piece_on_board ).and_return( rook, piece )
      allow( game ).to receive( :player_in_check? )
      allow( position ).to receive( :dup ).and_return copied_position
      allow( game ).to receive( :start_player_move )
      allow( game ).to receive( :restore_piece_to_original_position )
      allow( STDOUT ).to receive( :puts )
      allow( game ).to receive( :increase_piece_move_counter )
      allow( king ).to receive( :move_counter ).and_return 0
      allow( rook ).to receive( :move_counter ).and_return 0
    end

    it "expect the the board to be updated" do
      expect( game ).to receive( :update_the_board! ).with( king, "f", 1, copied_position)
      castle.castle_kingside( king, 1, player, enemy_player )
    end

    it "checks to see if king is in check" do
      expect( game ).to receive( :player_in_check? ).with( player, enemy_player )
      castle.castle_kingside( king, 1, player, enemy_player )
    end

    context "when the first move puts the king in check" do
      it "restores the board" do
        allow( game ).to receive( :player_in_check? ).and_return true
        expect( game ).to receive( :restore_piece_to_original_position ).
          with( king, copied_position, copied_position )
        castle.castle_kingside( king, 1, player, enemy_player )  
      end

      it "starts the player's move over again" do
        allow( game ).to receive( :player_in_check? ).and_return true
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_kingside( king, 1, player, enemy_player ) 
      end
    end

    context "when the space is occupied" do
      it "starts the player's move over again" do
        allow( piece ).to receive( :respond_to? ).and_return true
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_kingside( king, 1, player, enemy_player ) 
      end
    end

    it "places the king in the right position" do
      allow( game ).to receive( :player_in_check? ).and_return false
      expect( game ).to receive( :update_the_board! ).with( king, "g", 1, copied_position )
      castle.castle_kingside( king, 1, player, enemy_player ) 
    end

    context "when the second move puts the king in check" do
      it "restores the board" do
        allow( game ).to receive( :player_in_check? ).and_return( false, true )
        expect( game ).to receive( :restore_piece_to_original_position ).
          with( king, copied_position, copied_position )
        castle.castle_kingside( king, 1, player, enemy_player ) 
      end

      it "starts the player's move over again" do
        allow( game ).to receive( :player_in_check? ).and_return( false, true )
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_kingside( king, 1, player, enemy_player ) 
      end
    end

    context "when the king isn't in check when castling" do
      it "places the rook in the corret position" do
        allow( game ).to receive( :player_in_check? ).and_return( false, false )
        expect( game ).to receive( :update_the_board! ).with( rook, "f", 1, copied_position )
        castle.castle_kingside( king, 1, player, enemy_player ) 
      end

      it "updates the move counter on the king" do
        allow( game ).to receive( :player_in_check? ).and_return( false, false )
        expect( game ).to receive( :increase_piece_move_counter ).with( king )
        castle.castle_kingside( king, 1, player, enemy_player )
      end

      it "updates the move counter on the rook" do
        allow( game ).to receive( :player_in_check? ).and_return( false, false )
        expect( game ).to receive( :increase_piece_move_counter ).with( rook )
        castle.castle_kingside( king, 1, player, enemy_player )
      end
    end

    context "when the king has already moved" do
      it "starts the player's move over again" do
        allow( king ).to receive( :move_counter ).and_return 1
        allow( rook ).to receive( :move_counter ).and_return 0
        expect( game ).to receive( :start_player_move ).with( player, enemy_player )
        castle.castle_kingside( king, 1, player, enemy_player )
      end
    end
  end

  describe "#legal_to_castle?" do
    context "when a rook or king has already moved" do
      it "returns false" do
        expect( castle.legal_to_castle?( 0, 1 ) ).to be_false
      end

      it "returns false" do
        expect( castle.legal_to_castle?( 1, 0 ) ).to be_false
      end
    end

    context "when both rook and king haven't moved" do
      it "returns true" do
        expect( castle.legal_to_castle?( 0, 0 ) ).to be
      end
    end
  end
end