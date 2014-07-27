require "spec_helper"

describe EnPassant do
  
  let(:enpassant) { described_class.new game }
  let(:game) { stub_const "Game", Class.new }
  let(:pawn) { double() }
  let(:enemy_pawn) { double() }
  let(:enemy_pieces_list) { [pawn, pawn2, pawn3] }
  
  before(:each) do
    stub_const "Pawn", Class.new
  end
  
  describe "#can_en_passant?" do
    context "when pawn is traveling down" do
      context "when en_passant can be performed by a pawn" do
        it "returns true" do
          allow( game ).to receive( :legal_move? ).and_return true
          allow( pawn ).to receive( :orientation ).and_return :down
          allow( game ).to receive( :find_piece_on_board ).and_return( enemy_pawn )
          allow( pawn ).to receive( :new_file_position ).and_return "f"
          allow( pawn ).to receive( :position ).and_return Position.new( "e", 4 )
          allow( enemy_pawn ).to receive( :is_a? ).and_return true
          allow( enemy_pawn ).to receive( :move_counter ).and_return 1
          allow( enemy_pawn ).to receive( :can_be_captured_en_passant? ).and_return true
          expect( enpassant.can_en_passant?( pawn, :next ) ).to be
        end
      end
    
      context "when en_passant can NOT be performed by a pawn" do
        before( :each ) do
          allow( game ).to receive( :legal_move? ).and_return true
          allow( pawn ).to receive( :orientation ).and_return :down
          allow( pawn ).to receive( :position ).and_return Position.new( "e", 4 )
        end
        
        it "returns false when finding a null piece" do
          allow( game ).to receive( :find_piece_on_board ).and_return( NullPiece.new )
          allow( pawn ).to receive( :new_file_position ).and_return "d"
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
        
        it "returns false when enemy_pawn has moved more than once" do
          allow( game ).to receive( :find_piece_on_board ).and_return( enemy_pawn )
          allow( pawn ).to receive( :new_file_position ).and_return "d"
          allow( enemy_pawn ).to receive( :is_a? ).and_return true
          allow( enemy_pawn ).to receive( :move_counter ).and_return 2
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
        
        it "returns false when enemy pawn can longer be captured through en passant" do
          allow( game ).to receive( :find_piece_on_board ).and_return( enemy_pawn )
          allow( pawn ).to receive( :new_file_position ).and_return "d"
          allow( enemy_pawn ).to receive( :is_a? ).and_return true
          allow( enemy_pawn ).to receive( :move_counter ).and_return 1
          allow( enemy_pawn ).to receive( :can_be_captured_en_passant? ).and_return false
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
      end
    
      context "when the move is not a legal move" do
        it "returns false" do
          allow( pawn ).to receive( :orientation ).and_return :down
          allow( game ).to receive( :legal_move? ).and_return false
          allow( pawn ).to receive( :position ).and_return Position.new( "a", 4 )
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
      end
    end
    
    context "when pawn is traveling up" do
      context "when en_passant can be performed by a pawn" do
        it "returns true" do
          allow( game ).to receive( :legal_move? ).and_return true
          allow( pawn ).to receive( :orientation ).and_return :up
          allow( game ).to receive( :find_piece_on_board ).and_return( enemy_pawn )
          allow( pawn ).to receive( :new_file_position ).and_return "f"
          allow( pawn ).to receive( :position ).and_return Position.new( "e", 4 )
          allow( enemy_pawn ).to receive( :is_a? ).and_return true
          allow( enemy_pawn ).to receive( :move_counter ).and_return 1
          allow( enemy_pawn ).to receive( :can_be_captured_en_passant? ).and_return true
          expect( enpassant.can_en_passant?( pawn, :next ) ).to be
        end
      end
      
      context "when en_passant can NOT be performed by a pawn" do
        before( :each ) do
          allow( game ).to receive( :legal_move? ).and_return true
          allow( pawn ).to receive( :orientation ).and_return :up
          allow( pawn ).to receive( :position ).and_return Position.new( "e", 4 )
        end
        it "returns false when finding a null piece" do
          
          allow( game ).to receive( :find_piece_on_board ).and_return( NullPiece.new )
          allow( pawn ).to receive( :new_file_position ).and_return "d"
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
        
        it "returns false when the enemy piece has moved more than once" do
          allow( game ).to receive( :find_piece_on_board ).and_return( enemy_pawn )
          allow( pawn ).to receive( :new_file_position ).and_return "d"
          allow( enemy_pawn ).to receive( :is_a? ).and_return true
          allow( enemy_pawn ).to receive( :move_counter ).and_return 2
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
        
        it "returns false when enemy pawn can longer be captured through en passant" do
          allow( game ).to receive( :find_piece_on_board ).and_return( enemy_pawn )
          allow( pawn ).to receive( :new_file_position ).and_return "d"
          allow( enemy_pawn ).to receive( :is_a? ).and_return true
          allow( enemy_pawn ).to receive( :move_counter ).and_return 1
          allow( enemy_pawn ).to receive( :can_be_captured_en_passant? ).and_return false
          expect( enpassant.can_en_passant?( pawn, :previous ) ).to be_false
        end
      end
      
      context "when the move is not a legal move" do
        it "returns false" do
          allow( pawn ).to receive( :orientation ).and_return :up
          allow( game ).to receive( :legal_move? ).and_return false
          allow( pawn ).to receive( :position ).and_return Position.new( "h", 4 )
          expect( enpassant.can_en_passant?( pawn, :next ) ).to be_false
        end
      end
    end
  end
  
  describe "#capture_pawn_en_passant!" do
    context "when piece is moving down" do
      it "returns the space where the pawn will move" do
        allow( pawn ).to receive( :new_file_position ).and_return "f"
        allow( pawn ).to receive( :orientation ).and_return :down
        expect( enpassant.capture_pawn_en_passant!( pawn, :next ) ).to eq( ["f", 3, "e.p."] )
      end
    end
    
    context "when piece is moving up" do
      it "returns the sapce where the pawn will move" do
        allow( pawn ).to receive( :new_file_position ).and_return "d"
        allow( pawn ).to receive( :orientation ).and_return :up
        expect( enpassant.capture_pawn_en_passant!( pawn, :previous ) ).to eq( ["d", 6, "e.p."] )
      end
    end
  end
  
  describe "#update_enemy_piece_status_for_en_passant" do
    context "for black pieces" do
      it "changes the status of en passant for an enemy piece that could be captured through en passant" do
        allow( enemy_pawn ).to receive( :is_a? ).and_return true
        allow( enemy_pawn ).to receive( :move_counter ).and_return 1
        allow( enemy_pawn ).to receive( :captured? ).and_return false
        allow( enemy_pawn ).to receive( :can_be_captured_en_passant? ).and_return true
        allow( enemy_pawn ).to receive( :position ).and_return Position.new( "a", 4 )
        expect( enemy_pawn ).to receive( :update_en_passant_status! )
        enpassant.update_enemy_pawn_status_for_en_passant( [enemy_pawn], :black )
      end
    end
    
    context "for white pieces" do
      it "changes the status of en passant for an enemy piece that could be captured through en passant" do
        allow( enemy_pawn ).to receive( :is_a? ).and_return true
        allow( enemy_pawn ).to receive( :move_counter ).and_return 1
        allow( enemy_pawn ).to receive( :captured? ).and_return false
        allow( enemy_pawn ).to receive( :can_be_captured_en_passant? ).and_return true
        allow( enemy_pawn ).to receive( :position ).and_return Position.new( "a", 5 )
        expect( enemy_pawn ).to receive( :update_en_passant_status! )
        enpassant.update_enemy_pawn_status_for_en_passant( [enemy_pawn], :white )
      end
    end
  end
end