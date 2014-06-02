require_relative 'spec_helper'

describe Checkmate do
  
  let(:game) { double() }
  let(:checkmate) { described_class.new( game ) }
  let(:king) { double() }
  let(:piece) { double( reaplce_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:player) { double( team_pieces: [piece] ) }
  let(:player2) { double( team_pieces: [] ) }
  
  
  describe "#move_king_in_all_possible_spots" do
    it "checks to see where a king can move and not be in check" do
      # determine all possible moves for the king
      # iterate through each move and see if the king is in check
      # if king is not in check, save the spot, otherwise move to the next spot
      expect( game ).to receive( :board ).and_return game
      expect( game ).to receive( :dup ).and_return( Array.new( 8 ) { |cell| Array.new( 8 ) } )
      expect( game ).to receive( :convert_to_file_and_rank ).exactly( 6 ).times.and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      expect( player ).to receive( :king_piece ).and_return king
      expect( king ).to receive( :position ).exactly( 6 ).times
      expect( king ).to receive( :determine_possible_moves ).and_return( [[3, 4], [4, 3], [5, 3], [5, 4], [4, 5], [3, 5]] )
      expect( game ).to receive( :move_piece! ).exactly( 6 ).times
      expect( game ).to receive( :player_in_check? ).exactly( 6 ).times
      expect( game ).to receive( :replace_board ).exactly( 6 ).times
      expect( piece ).to receive( :replace_board ).exactly( 6 ).times
      checkmate.move_king_in_all_possible_spots( player, player2 )
      expect( checkmate.possible_moves.size ).to eq( 6 )
    end
  end
end