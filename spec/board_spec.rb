require "spec_helper"

describe Board do
    
  let(:game_board) { described_class.new }
  let(:piece) { double( position: Position.new( "f", 5 ), team: :black, orientation: :up ) }
  let(:piece2) { double( position: Position.new( "a", 8 ), team: :white, orientation: :up ) }
  let(:piece3) { double( team: :black ) }
  let(:piece4) { double( position: Position.new( "f", 5 ), team: :black, orientation: :down ) }
  let(:piece5) { double( position: Position.new( "e", 4 ), team: :black ) }
  let(:piece6) { double( position: Position.new( "g", 1 ), team: :black ) }
  let(:position) { Position.new( "c", 1 ) }
  let(:player) { Player.new( :white ) }
  let(:response) do
    [ "piece1","piece2","piece3","piece4","piece5","piece6","piece7",
      "piece8","piece9","piece10","piece11","piece12","piece13",
      "piece14","piece15","piece16" ]
  end
  
  before (:each) do
    allow( game_board.possible_moves ).to receive( :clear )
  end

  describe "#create_board" do
    it "creates a chess board" do
      expect( game_board.chess_board ).to eq( Array.new( 8 ) { |cell| Array.new( 8 ) } )
    end
  end
  
  describe "#legal_move" do
    it "detects if a piece is trying to be placed off the board" do
      expect( game_board.legal_move?( 4, 6 ) ).to be
      expect( game_board.legal_move?( 5, 8 ) ).to be_false
      expect( game_board.legal_move?( 8, 0 ) ).to be_false
    end
  end
  
  describe "#remove_marker" do
    it "removes a pieces marker" do
      game_board.chess_board[3][5] = piece
      game_board.remove_marker( Position.new( "f", 5 ) )
      expect( game_board.chess_board[3][5] ).to be_nil
    end
  end
  
  describe "#update_board" do
    context "when a space is occupied" do
      it "removes and replaces the opposing piece with new piece" do
        game_board.chess_board[3][5] = piece2
        expect( piece2 ).to receive( :piece_captured )
        game_board.update_board( piece )
        expect( game_board.chess_board[3][5] ).to eq( piece )
      end
    end
    
    context "when a space is open" do
      it "places the piece in the cell" do
        game_board.update_board( piece )
        expect( game_board.chess_board[3][5] ).to eq( piece )
      end
    end
  end
  
  describe "#move_straight?" do
    context "when moving from bottom to top" do
      it "checks if a piece can move straight" do
        expect( game_board.move_straight?( piece ) ).to be_true
      end
      
      it "does NOT let a piece go off the board" do
        expect( game_board.move_straight?( piece2 ) ).to be_false
      end
    end
    
    context "when moving from top to bottom" do
      it "checks if a piece can move straight" do
        game_board.chess_board[4][5] = piece2
        expect( game_board.move_straight?( piece4 ) ).to be_false
      end
    end
    
    context "when at the edge of the board" do
      it "prevents the piece from moving off the board" do
        expect( game_board.move_straight?( piece2 )).to be_false
      end
    end
  end
  
  describe "#move_forward_diagonally?" do
    context "when moving from the bottom to top" do
      context "when the spaces are empty" do
        it "checks if a piece can move forward diagonally to the left" do
          expect( game_board.move_forward_diagonally?( piece, :left ) ).to be_false
        end
    
        it "checks if a piece can move forward digaonally to the right" do
          expect( game_board.move_forward_diagonally?( piece, :right ) ).to be_false
        end
        
        it "doesn't allow for an illegal move" do
          expect( game_board.move_straight?( piece2 )).to be_false
        end
      end
    
      context "when there is an enemy piece" do
        it "checks if a piece can move forward diagonally to the left" do
          game_board.chess_board[2][4] = piece2
          expect( game_board.move_forward_diagonally?( piece, :left ) ).to be_true
        end
      
        it "check is a piece can move forward diagonally to the right" do
          game_board.chess_board[2][6] = piece2
          expect( game_board.move_forward_diagonally?( piece, :right ) ).to be_true
        end
      end
    
      context "when there is a friendly piece" do
        it "checks if a piece can move forward diagonally to the left" do
          game_board.chess_board[2][4] = piece3
          expect( game_board.move_forward_diagonally?( piece, :left ) ).to be_false
        end
      
        it "check is a piece can move forward diagonally to the right" do
          game_board.chess_board[2][6] = piece3
          expect( game_board.move_forward_diagonally?( piece, :right ) ).to be_false
        end
      end
    end
    
    context "when moving from top to bottom" do
      context "when the spaces are empty" do
        it "checks if a piece can move forward diagonally to the left" do
          expect( game_board.move_forward_diagonally?( piece4, :left ) ).to be_false
        end
      
        it "checks if a piece can move forward digaonally to the right" do        
          expect( game_board.move_forward_diagonally?( piece4, :right ) ).to be_false
        end
      end
    
      context "when there is an enemy piece" do
        it "checks if a piece can move forward diagonally to the left" do
          game_board.chess_board[4][6] = piece2
          expect( game_board.move_forward_diagonally?( piece4, :left ) ).to be_true
        end
    
        it "checks if a piece can move forward diagonally to the right" do
          game_board.chess_board[4][4] = piece2
          expect( game_board.move_forward_diagonally?( piece4, :right ) ).to be_true
        end
      end
    
      context "when there is a friendly piece" do
        it "checks if a piece can move forward diagonally to the left" do
          game_board.chess_board[4][6] = piece3
          expect( game_board.move_forward_diagonally?( piece, :left ) ).to be_false
        end
    
        it "checks if a piece can move forward diagonally to the right" do
          game_board.chess_board[4][4] = piece3
          expect( game_board.move_forward_diagonally?( piece, :right ) ).to be_false
        end
      end
    end
  end
  
  describe "#find_horizontal_spaces" do
    
    context "when there are no other pieces in the same row" do
      it "returns an array of possible moves" do
        game_board.find_horizontal_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 7 )
      end
    end
    
    context "when there is an enemy in the same row" do
      it "returns an array of possible moves with that space included and not any others past it" do
        game_board.chess_board[4][2] = piece2
        game_board.find_horizontal_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 5 )
        end
    end
    
    context "when there is a friendly piece in the same row" do
      it "returns an array not including that space or any more after it" do
        game_board.chess_board[4][5] = piece3
        game_board.find_horizontal_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 4 )
      end
    end
  end
  
  describe "#find_vertical_spaces" do
    
    context "when there are no other pieces in the same column" do
      it "return an array of possible moves" do
        game_board.find_vertical_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 7 )
      end
    end
    
    context "when there is an enemy in the same column" do
      it "returns an array of possible moves with that space included and not any others past it" do
        game_board.chess_board[2][4] = piece2
        game_board.find_vertical_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 5 )
      end
    end
    
    context "when there is a friendly piece in the same row" do
      it "returns an array not including that space or any more after it" do
        game_board.chess_board[6][4] = piece3
        game_board.find_vertical_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 5 )
      end
    end
  end
  
  describe "#find_diagonal_spaces" do
    
    context "when there are no other pieces diagonally" do
      it "returns an array of possible moves" do
        game_board.find_diagonal_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 13 )
      end
    end
    
    context "when there is an enemy in a diagonal space" do
      it "returns an array of possible moves with that space included but not any others past it" do
        game_board.chess_board[2][2] = piece2
        game_board.chess_board[6][2] = piece2
        game_board.find_diagonal_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 10 )
      end
    end
    
    context "when there is a friendly piece in the same diagonal space" do
      it "returns an array not including that sapce or any more after it" do
        game_board.chess_board[2][2] = piece3
        game_board.chess_board[6][2] = piece3
        game_board.chess_board[3][5] = piece3
        game_board.find_diagonal_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 5 )
      end
    end
  end
  
  describe "#find_knight_spaces" do
    
    context "when there are no surrounding pieces" do
      it "returns an array of all possible moves" do
        game_board.find_knight_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 8 )
      end
    end
    
    context "when there are surrounding enemy pieces" do
      it "returns an array of possibles moves with those space included" do
        game_board.chess_board[2][3] = piece2
        game_board.chess_board[5][2] = piece2
        game_board.find_knight_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 8 )
      end
    end
    
    context "when there are surrounding friendly pieces" do
      it "returns an array not including that space" do
        game_board.chess_board[2][3] = piece3
        game_board.chess_board[5][2] = piece3
        game_board.find_knight_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 6 )
      end
    end
    
    context "when at the edge of the board" do
      it "does NOT include moves off the board" do
        game_board.find_knight_spaces( piece6 )
        expect( game_board.possible_moves.size ).to eq( 3 )
      end
    end
  end
  
  describe "#find_king_spaces" do
    context "when there are no surrounding pieces" do
      it "returns an array of all possible moves" do
        game_board.find_king_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 8 )
      end
    end

    context "when there are surrounding enemy pieces" do
      it "returns an array of possible moves with those spaces included" do
        game_board.chess_board[3][3] = piece2
        game_board.chess_board[5][5] = piece2
        game_board.find_king_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 8 )
      end
    end

    context "when there are surrounding enemy pieces" do
      it "returns an array of possible moves not including those spaces" do
        game_board.chess_board[3][3] = piece3
        game_board.chess_board[5][5] = piece3
        game_board.find_king_spaces( piece5 )
        expect( game_board.possible_moves.size ).to eq( 6 )
      end
    end
  end
  
  describe "#convert_to_file_position" do
    it "converts an index into a file position" do
      expect( game_board.convert_to_file_position( 0 ) ).to eq( "a" )
    end
  end
  
  describe "#convert_to_rank_position" do
    it "converts an index into a rank position" do
      expect( game_board.convert_to_rank_position( 5 ) ).to eq( 3 )
    end
  end
  
  describe "#find_piece" do
    it "finds the position of a king piece" do
      game_board.chess_board[7][2] = piece3
      expect( game_board.find_piece( position ) ).to eq( piece3 )
    end
  end

  describe "#valid_space?" do
    it "determines if a space can be occupied" do
      expect( game_board.valid_space?( 3, 2, piece5 ) ).to be_true
    end
  end
  
  describe "#place_pieces_on_board" do
    it "places the white pieces in their starting location" do
      expect( player ).to receive( :team_pieces ).and_return response
      expect( game_board ).to receive( :update_board ).exactly( 16 ).times
      game_board.place_pieces_on_board( player )
    end
  end
end