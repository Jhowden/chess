require_relative 'spec_helper'

describe Checkmate do
  
  let(:game) { double() }
  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:king) { double() }
  let(:position) {double( file: "b", rank: 4)}
  let(:piece) { double( captured?: false ) }
  let(:piece2) { double( captured?: false ) }
  let(:piece3) { double( captured?: false ) }
  let(:player) { double() }
  let(:player2) { double( team_pieces: [] ) }
  let(:null_piece) { stub_const( "NullPiece", Class.new ) }
  let(:checkmate) { described_class.new( game ) }

  before(:each) do
    allow( player ).to receive( :team_pieces ).and_return [piece]
    allow( king ).to receive( :position ).and_return position
    allow( position ).to receive( :dup ).and_return position
    allow( game ).to receive( :board ).and_return board
    allow( player ).to receive( :king_piece ).and_return king
    allow( game ).to receive( :player_in_check? ).with( player, player2).
      and_return false
    allow( piece2 ).to receive( :position ).and_return piece2
    allow( game ).to receive( :update_the_board! )
  end
  
  describe "#move_king_in_all_possible_spots" do
    
    context "when king has possible moves" do
      context "when king does not capture an enemy piece with move" do
        it "checks to see where a king can move and not be in check" do
          allow( game ).to receive( :find_piece_on_board ).and_return piece
          allow( piece ).to receive( :team ).and_return :black
          allow( piece ).to receive( :position ).and_return piece
          allow( piece ).to receive( :file_position_converter ).and_return 3
          allow( piece ).to receive( :rank_position_converter ).and_return 4
          allow( piece ).to receive( :captured! ).and_return false
          allow( king ).to receive( :determine_possible_moves ).
            and_return( [["e", 6], ["f", 6], ["g", 6], ["e", 5], ["g", 5], ["e", 4], ["f", 4], ["g", 4]] )
          allow( position ).to receive( :rank ).and_return 3
          checkmate.move_king_in_all_possible_spots( player, player2 )
          expect( checkmate.possible_moves ).
            to eq( [["b", 3, "e", 6], ["b", 3, "f", 6], ["b", 3, "g", 6],
                    ["b", 3, "e", 5], ["b", 3, "g", 5], ["b", 3, "e", 4],
                    ["b", 3, "f", 4], ["b", 3, "g", 4]] )
        end
      end
      
      context "when king does capture an enemy piece with move" do
        it "checks to see where a king can move and not be in check" do
          allow( game ).to receive( :find_piece_on_board ).and_return piece
          allow( piece ).to receive( :team ).and_return nil
          allow( king ).to receive( :determine_possible_moves ).
            and_return( [["e", 6], ["f", 6], ["g", 6], ["e", 5], ["g", 5], ["e", 4], ["f", 4], ["g", 4]] )
          allow( position ).to receive( :rank ).and_return 3
          checkmate.move_king_in_all_possible_spots( player, player2 )
          expect( checkmate.possible_moves ).
            to eq( [["b", 3, "e", 6], ["b", 3, "f", 6], ["b", 3, "g", 6],
                    ["b", 3, "e", 5], ["b", 3, "g", 5], ["b", 3, "e", 4],
                    ["b", 3, "f", 4], ["b", 3, "g", 4]] )
        end
      end
    end

    context "when the king has no possible moves" do
      it "returns an empty array" do
        allow( king ).to receive( :determine_possible_moves ).and_return []
        checkmate.move_king_in_all_possible_spots( player, player2 )
        expect( checkmate.possible_moves ).to eq( [] )
      end
    end
  end
  
  describe "#determine_enemy_piece_map" do
    before(:each) do
      allow( piece ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 4], ["d", 5]] )
      allow( player2 ).to receive( :king_piece ).and_return king
    end

    it "creates a map of the piece's who can capture the king" do
      expect( checkmate.determine_enemy_piece_map( player2, player ) ).to eq( { piece => [["a", 4], ["b", 4], ["d", 5]] } )
    end

    it "can handle multiple pieces that put the king in check" do
      allow( player ).to receive( :team_pieces ).and_return [piece, piece2]
      allow( piece2 ).to receive( :determine_possible_moves ).and_return( [["h", 4], ["b", 4], ["b", 4]] )
      expect( checkmate.determine_enemy_piece_map( player2, player ) ).
        to eq( { piece => [["a", 4], ["b", 4], ["d", 5]], piece2 => [["h", 4], ["b", 4], ["b", 4]] } )
    end
  end

  describe "#capture_piece_threatening_king" do
    it "checks to see if good pieces can capture the enemy piece threatening the king" do
      allow( piece ).to receive( :position ).and_return piece
      allow( piece ).to receive( :file ).and_return "a"
      allow( piece ).to receive( :rank ).and_return 5
      allow( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
      allow( player2 ).to receive( :team_pieces ).and_return [piece]
      allow( piece ).to receive( :determine_possible_moves ).
        and_return( [["a", 4], ["b", 4], ["d", 5]])
      allow( piece2 ).to receive( :determine_possible_moves ).
        and_return( [["a", 5], ["a", 4], ["a", 3], ["a", 2], ["a", 1]] )
      allow( piece3 ).to receive( :determine_possible_moves ).
        and_return( [["a", 4], ["b", 3], ["c", 2], ["d", 1]] )
      allow( piece2 ).to receive( :dup ).and_return piece2
      allow( piece2 ).to receive( :file ).and_return "d"
      allow( piece2 ).to receive( :rank ).and_return 5
      allow( piece ).to receive( :file_position_converter ).and_return 3
      allow( piece ).to receive( :rank_position_converter ).and_return 5
      allow( piece ).to receive( :captured! )
      checkmate.capture_piece_threatening_king( player, player2 )
      expect( checkmate.possible_moves ).to eq( [["d", 5, "a", 5]] )
    end

    it "exits out of the method if there are more than one enemy piece that has the king in check" do
      allow( player2 ).to receive( :team_pieces ).and_return [piece, piece3]
      allow( piece ).to receive( :determine_possible_moves ).and_return [["b", 4], ["d", 5]]
      allow( piece3 ).to receive( :determine_possible_moves ).and_return [["a", 4], ["b", 4]]
      expect( player ).to_not receive( :team_pieces )
      checkmate.capture_piece_threatening_king( player, player2 )
    end

    it "returns an empty array if no pieces can capture enemy piece" do
      allow( piece ).to receive( :position ).and_return piece
      allow( piece ).to receive( :file ).and_return "a"
      allow( piece ).to receive( :rank ).and_return 5
      allow( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
      allow( player2 ).to receive( :team_pieces ).and_return [piece]
      allow( piece ).to receive( :determine_possible_moves ).
        and_return( [["a", 4], ["b", 4], ["d", 5]])
      allow( piece2 ).to receive( :determine_possible_moves ).
        and_return( [["b", 5], ["a", 4], ["a", 3], ["a", 2], ["a", 1]] )
      allow( piece3 ).to receive( :determine_possible_moves ).
        and_return( [["b", 4], ["b", 3], ["c", 2], ["d", 1]] )
      checkmate.capture_piece_threatening_king( player, player2 )
      expect( checkmate.possible_moves ).to eq( [] )
    end
  end

 #  describe "#block_enemy_piece" do
 #    it "checks to see if any good pieces can block the enemy piece threatening the king" do
 #      allow( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
 #      allow( player2 ).to receive( :team_pieces ).and_return [piece]
 #      allow( piece ).to receive( :determine_possible_moves ).
 #        and_return( [["a", 4], ["a", 3], ["a", 2], ["a", 1], ["b", 4]] )
 #      allow( game ).to receive( :convert_to_file_and_rank ).and_return [0, 3]
 #      allow( piece2 ).to receive( :determine_possible_moves ).and_return( [["a", 5], ["a", 4], ["a", 3], ["a", 2]] )
 #      allow( piece3 ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 3], ["c", 2], ["d", 1]] )
 #      allow( piece2 ).to receive( :file ).and_return "d"
 #      allow( piece2 ).to receive( :rank ).and_return 5
 #      allow( piece3 ).to receive( :position ).and_return piece3
 #      allow( piece3 ).to receive( :file ).and_return "c"
 #      allow( piece3 ).to receive( :rank ).and_return 4
 #      checkmate.block_enemy_piece( player, player2 )
 #      expect( checkmate.possible_moves ).to eq( [["d", 5, "a", 4], ["d", 5, "a", 3], ["d", 5, "a", 2], ["c", 4, "a", 4]] )
 #    end
 #
 #    it "exits out of the method if there are more than one enemy piece that has the king in check" do
 #      allow( player2 ).to receive( :team_pieces ).and_return [piece, piece3]
 #      allow( piece ).to receive( :determine_possible_moves ).and_return [["b", 4], ["d", 5]]
 #      allow( piece3 ).to receive( :determine_possible_moves ).and_return [["a", 4], ["b", 4]]
 #      expect( player ).to_not receive( :team_pieces )
 #      checkmate.block_enemy_piece( player, player2 )
 #    end
 #
 #    it "returns an empty array when there are no pieces that can block an enemy piece" do
 #      allow( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
 #      allow( player2 ).to receive( :team_pieces ).and_return [piece]
 #      allow( piece ).to receive( :determine_possible_moves ).
 #        and_return( [["a", 4], ["a", 3], ["a", 2], ["a", 1], ["b", 4]] )
 #      allow( game ).to receive( :convert_to_file_and_rank ).and_return [0, 3]
 #      allow( piece2 ).to receive( :determine_possible_moves ).and_return( [["c", 5], ["d", 4], ["d", 3], ["d", 2]] )
 #      allow( piece3 ).to receive( :determine_possible_moves ).and_return( [["h", 4], ["h", 3], ["e", 2], ["e", 1]] )
 #      checkmate.block_enemy_piece( player, player2 )
 #      expect( checkmate.possible_moves ).to eq( [] )
 #    end
 #  end
 #
  # describe "#find_checkmate_escape_moves" do
  #   it "finds all the possible moves to escape checkmate" do
  #     allow( piece ).to receive( :position ).and_return piece
  #     allow( piece ).to receive( :file ).and_return "a"
  #     allow( piece ).to receive( :rank ).and_return 5
  #     allow( player ).to receive( :team_pieces ).and_return( [piece2, piece3] )
  #     allow( player2 ).to receive( :team_pieces ).and_return [piece]
  #     allow( piece ).to receive( :determine_possible_moves ).
  #       and_return( [["a", 4], ["a", 3], ["a", 2], ["a", 1], ["b", 4]] )
  #     allow( game ).to receive( :convert_to_file_and_rank ).and_return [0, 3]
  #     allow( piece2 ).to receive( :determine_possible_moves ).and_return( [["a", 5], ["a", 4], ["a", 3], ["a", 2]] )
  #     allow( piece3 ).to receive( :determine_possible_moves ).and_return( [["a", 4], ["b", 3], ["c", 2], ["d", 1]] )
  #     allow( piece2 ).to receive( :file ).and_return "d"
  #     allow( piece2 ).to receive( :rank ).and_return 5
  #     allow( piece3 ).to receive( :position ).and_return piece3
  #     allow( piece3 ).to receive( :file ).and_return "c"
  #     allow( piece3 ).to receive( :rank ).and_return 4
  #     allow( king ).to receive( :determine_possible_moves ).
  #       and_return( [["e", 6], ["f", 6]] )
  #     allow( game ).to receive( :convert_to_file_and_rank ).
  #       and_return( [[2, 4], [2, 5]] )
  #     expect( checkmate.find_checkmate_escape_moves( player, player2 ) ).
  #       to eq( ["b4e6", "b4f6", "d5a5", "d5a4", "d5a3", "d5a2", "c4a4"] )
  #   end
  # end
end