require_relative 'board'

describe Board do
  
  let(:game_board) { described_class.new }
  let(:piece) { double( position: Position.new( "f", 5 ), team: :black, orientation: :up ) }
  let(:piece2) { double( team: :white, orientation: :up ) }
  let(:piece3) { double( team: :black ) }
  let(:piece4) { double( position: Position.new( "f", 5 ), team: :black, orientation: :down ) }
  let(:piece5) { double( team: :black ) }
  
  before (:each) do
    stub_const "Position", Class.new
    allow( Position ).to receive( :new ).and_return( Position )
    game_board.create_board
    allow( Position ).to receive( :file_position_converter ).and_return( 5 )
    allow( Position ).to receive( :rank_position_converter ).and_return( 3 )
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
  
  describe "#move_or_capture_piece" do
    context "when a space is occupied" do
      it "removes and replaces the opposing piece with new piece" do
        game_board.chess_board[3][5] = piece2
        captured_piece = game_board.move_or_capture_piece( piece )
        expect( game_board.chess_board[3][5] ).to eq( piece )
        expect( captured_piece ).to eq( piece2 )
      end
    end
    
    context "when a space is open" do
      it "places the piece in the cell" do
        captured_piece = game_board.move_or_capture_piece( piece )
        expect( captured_piece ).to be_nil
        expect( game_board.chess_board[3][5] ).to eq( piece )
      end
    end
  end
  
  describe "#move_straight?" do
    context "when moving from bottom to top" do
      it "checks if a piece can move straight" do
        expect( game_board.move_straight?( piece ) ).to be_true
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
        allow( piece2 ).to receive( :position ).and_return( piece2 )
        allow( piece2 ).to receive( :file_position_converter ).and_return( 0 )
        allow( piece2 ).to receive( :rank_position_converter ).and_return( 0 )
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
          allow( piece2 ).to receive( :position ).and_return( piece2 )
          allow( piece2 ).to receive( :file_position_converter ).and_return( 0 )
          allow( piece2 ).to receive( :rank_position_converter ).and_return( 0 )
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
    
    before (:each) do
      allow( piece5 ).to receive( :position ).and_return( piece5 )
      allow( piece5 ).to receive( :file_position_converter ).and_return( 4 )
      allow( piece5 ).to receive( :rank_position_converter ).and_return( 4 )
      allow( game_board.possible_moves ).to receive( :clear )
    end
    
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
    
    before (:each) do
      allow( piece5 ).to receive( :position ).and_return( piece5 )
      allow( piece5 ).to receive( :file_position_converter ).and_return( 4 )
      allow( piece5 ).to receive( :rank_position_converter ).and_return( 4 )
      allow( game_board.possible_moves ).to receive( :clear )
    end
    
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
    
    before (:each) do
      allow( piece5 ).to receive( :position ).and_return( piece5 )
      allow( piece5 ).to receive( :file_position_converter ).and_return( 4 )
      allow( piece5 ).to receive( :rank_position_converter ).and_return( 4 )
      allow( game_board.possible_moves ).to receive( :clear )
    end
    
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
end