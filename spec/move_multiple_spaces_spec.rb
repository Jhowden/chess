require 'spec_helper'

describe MoveMultipleSpaces do
  subject { Board.new.extend( described_class ) }
  
  let(:piece) { double( team: :white) }
  let(:opposing_piece) { double( team: :black) }
  let(:friendly_piece) { double( team: :white) }

  describe "#find_surrounding_spaces" do
    it "finds the valid moves for a knight or king" do
      allow( piece ).to receive( :position ).twice.and_return piece
      allow( piece ).to receive( :file_position_converter ).and_return 4
      allow( piece ).to receive( :rank_position_converter ).and_return 3
      subject.find_surrounding_spaces( piece, [[-1, -2], [-2, -1], [1, -2]] )
      expect( subject.possible_moves ).to eq( [["d", 7], ["c", 6], ["f", 7]] )
    end
  end

  describe "#find_possible_horizontal_spaces" do
    context "when moving to the left" do
      it "finds all the empty spaces to the left of the piece" do
        subject.find_possible_horizontal_spaces( 4, 3, piece, -1 )
        expect( subject.possible_moves ).to eq( [["d", 5], ["c", 5], ["b", 5], ["a", 5]] )
      end
      
      it "finds a space occupied by an enemy to the left of the piece" do
        subject.chess_board[3][2] = opposing_piece
        subject.find_possible_horizontal_spaces( 4, 3, piece, -1 )
        expect( subject.possible_moves ).to eq( [["d", 5], ["c", 5]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[3][2] = friendly_piece
        subject.find_possible_horizontal_spaces( 4, 3, piece, -1 )
        expect( subject.possible_moves ).to eq( [["d", 5]] )
      end
    end
  
    context "when moving to the right" do
      it "finds all the empty spaces to the left of the piece" do
        subject.find_possible_horizontal_spaces( 4, 3, piece, 1 )
        expect( subject.possible_moves ).to eq( [["f", 5], ["g", 5], ["h",5]] )
      end
      
      it "finds a space occupied by an enemy to the left of the piece" do
        subject.chess_board[3][6] = opposing_piece
        subject.find_possible_horizontal_spaces( 4, 3, piece, 1 )
        expect( subject.possible_moves ).to eq( [["f", 5], ["g",5 ]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[3][6] = friendly_piece
        subject.find_possible_horizontal_spaces( 4, 3, piece, 1 )
        expect( subject.possible_moves ).to eq( [["f", 5]] )
      end
    end
  end
  
  describe "#find_possible_vertical_spaces" do
    context "when moving up" do
      it "finds all the empty spaces above the piece" do
        subject.find_possible_vertical_spaces( 4, 3, piece, -1 )
        expect( subject.possible_moves ).to eq( [["e", 6], ["e", 7], ["e",8]] )
      end
      
      it "finds a space occupied by an enemy above the piece" do
        subject.chess_board[1][4] = opposing_piece
        subject.find_possible_vertical_spaces( 4, 3, piece, -1 )
        expect( subject.possible_moves ).to eq( [["e", 6], ["e", 7]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[1][4] = friendly_piece
        subject.find_possible_vertical_spaces( 4, 3, piece, -1 )
        expect( subject.possible_moves ).to eq( [["e", 6]] )
      end
    end
  
    context "when moving down" do
      it "finds all the empty spaces below the piece" do
        subject.find_possible_vertical_spaces( 4, 3, piece, 1 )
        expect( subject.possible_moves ).to eq( [["e", 4], ["e", 3], ["e",2], ["e", 1]] )
      end
      
      it "finds a space occupied by an enemy below the piece" do
        subject.chess_board[5][4] = opposing_piece
        subject.find_possible_vertical_spaces( 4, 3, piece, 1 )
        expect( subject.possible_moves ).to eq( [["e", 4], ["e", 3]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[5][4] = friendly_piece
        subject.find_possible_vertical_spaces( 4, 3, piece, 1 )
        expect( subject.possible_moves ).to eq( [["e", 4]] )
      end
    end
  end
  
  describe "#find_possible_diagonally_spaces" do
    context "when finding spaces to the top left" do
      it "finds all the empty spaces to the top-left of the piece" do
        subject.find_possible_diagonally_spaces( 4, 3, piece, -1, -1 )
        expect( subject.possible_moves ).to eq( [["d", 6], ["c", 7], ["b", 8]] )
      end
      
      it "finds a space occupied by an enemy to the top-left of the piece" do
        subject.chess_board[1][2] = opposing_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, -1, -1 )
        expect( subject.possible_moves ).to eq( [["d", 6], ["c", 7]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[1][2] = friendly_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, -1, -1 )
        expect( subject.possible_moves ).to eq( [["d", 6]] )
      end
    end
    
    context "when finding spaces to the top right" do
      it "finds all the empty spaces to the top-right of the piece" do
        subject.find_possible_diagonally_spaces( 4, 3, piece, -1, 1 )
        expect( subject.possible_moves ).to eq( [["f", 6], ["g", 7], ["h",8]] )
      end
      
      it "finds a space occupied by an enemy to the left of the piece" do
        subject.chess_board[1][6] = opposing_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, -1, 1 )
        expect( subject.possible_moves ).to eq( [["f", 6], ["g", 7]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[1][6] = friendly_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, -1, 1 )
        expect( subject.possible_moves ).to eq( [["f", 6]] )
      end
    end
    
    describe "when finding spaces to the bottom left" do
      it "finds all the empty spaces to the bottom-left of the piece" do
        subject.find_possible_diagonally_spaces( 4, 3, piece, 1, -1 )
        expect( subject.possible_moves ).to eq( [["d", 4], ["c", 3], ["b",2], ["a", 1]] )
      end
      
      it "finds a space occupied by an enemy to the bottom-left of the piece" do
        subject.chess_board[6][1] = opposing_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, 1, -1 )
        expect( subject.possible_moves ).to eq( [["d", 4], ["c", 3], ["b",2]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[6][1] = friendly_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, 1, -1 )
        expect( subject.possible_moves ).to eq( [["d", 4], ["c", 3]] )
      end
    end
    
    context "when finding spaces to the bottom right" do
      it "finds all the empty spaces to the bottom-right of the piece" do
        subject.find_possible_diagonally_spaces( 4, 3, piece, 1, 1 )
        expect( subject.possible_moves ).to eq( [["f", 4], ["g", 3], ["h",2]] )
      end
      
      it "finds a space occupied by an enemy to the bottom-right of the piece" do
        subject.chess_board[5][6] = opposing_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, 1, 1 )
        expect( subject.possible_moves ).to eq( [["f", 4], ["g", 3]] )
      end
      
      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[5][6] = friendly_piece
        subject.find_possible_diagonally_spaces( 4, 3, piece, 1, 1 )
        expect( subject.possible_moves ).to eq( [["f", 4]] )
      end
    end
  end
end