require_relative 'spec_helper'

describe DetermineMultipleMoves do
  subject { Object.new.extend( described_class ) }# creating a new object that has those methods and stub those out
  
  let(:piece) { double() }
  
  before( :each ) do
    allow( subject ).to receive( :possible_moves ).and_return( [] )
  end
  
  describe "#find_surrounding_spaces" do
    it "finds the valid moves for a knight or king" do
      # All these expects... shouldn't some be allows?
      # What are you testing and what is merely necessary to get there?
      expect( piece ).to receive( :position ).twice.and_return piece
      expect( piece ).to receive( :file_position_converter ).and_return 3
      expect( piece ).to receive( :rank_position_converter ).and_return 3
      expect( subject ).to receive( :legal_move? ).and_return( true, true, false )
      expect( subject ).to receive( :valid_space? ).and_return( true, true )
      expect( subject ).to receive( :convert_to_file_position ).twice.and_return( 4, 2 )
      expect( subject ).to receive( :convert_to_rank_position ).twice.and_return( 5, 3 )
      subject.find_surrounding_spaces( piece, [[-1, -2], [-2, -1], [1, -2]] )
      expect( subject.possible_moves ).to eq( [[4,5],[2,3]] )
    end
  end
  
  describe "#find_spaces_to_the_left" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 3, 2, 1 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 3 )
      subject.find_spaces_to_the_left( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[3, 3], [2, 3], [1,3]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 3 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 3 )
      subject.find_spaces_to_the_left( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[3, 3]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_to_the_left( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_to_the_right" do
    it "finds all the empty spaces to the left of the piece" do
      # Mocking or stubbing the thing you are testing is FORBIDDEN!
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 5, 6, 7 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 3 )
      subject.find_spaces_to_the_right( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[5, 3], [6, 3], [7,3]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      # And so on...
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 5 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 3 )
      subject.find_spaces_to_the_right( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[5, 3]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_to_the_right( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_above" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 4 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 4, 5, 6 )
      subject.find_spaces_above( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[4, 4], [4, 5], [4,6]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 4 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 4 )
      subject.find_spaces_above( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[4, 4]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_above( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_below" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 4 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 2, 1, 0 )
      subject.find_spaces_below( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[4, 2], [4, 1], [4,0]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 4 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 2 )
      subject.find_spaces_below( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[4, 2]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_below( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_diagonally_top_left" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 4, 3, 2 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 2, 1, 0 )
      subject.find_spaces_diagonally_top_left( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[4, 2], [3, 1], [2,0]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 3 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 2 )
      subject.find_spaces_diagonally_top_left( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[3, 2]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_diagonally_top_left( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_diagonally_top_right" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 5, 6, 7 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 2, 1, 0 )
      subject.find_spaces_diagonally_top_right( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[5, 2], [6, 1], [7,0]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 5 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 2 )
      subject.find_spaces_diagonally_top_right( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[5, 2]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_diagonally_top_right( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_diagonally_bottom_left" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 3, 2, 1 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 4, 5, 6 )
      subject.find_spaces_diagonally_bottom_left( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[3, 4], [2, 5], [1,6]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 3 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 4 )
      subject.find_spaces_diagonally_bottom_left( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[3, 4]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_diagonally_bottom_left( 4, 3, piece )
    end
  end
  
  describe "#find_spaces_diagonally_bottom_right" do
    it "finds all the empty spaces to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true, true, true, false )
      expect( subject ).to receive( :empty_space? ).and_return( true, true, true )
      expect( subject ).to receive( :convert_to_file_position ).exactly( 3 ).times.
        and_return( 5, 6, 7 )
      expect( subject ).to receive( :convert_to_rank_position ).exactly( 3 ).times.
        and_return( 4, 5, 6 )
      subject.find_spaces_diagonally_bottom_right( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[5, 4], [6, 5], [7,6]] )
    end
    
    it "finds a space occupied by an enemy to the left of the piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( true )
      expect( subject ).to receive( :convert_to_file_position ).and_return( 5 )
      expect( subject ).to receive( :convert_to_rank_position ).and_return( 4 )
      subject.find_spaces_diagonally_bottom_right( 4, 3, piece )
      expect( subject.possible_moves ).to eq( [[5, 4]] )
    end
    
    it "does not track spaces that are occupied by a friendly piece" do
      expect( subject ).to receive( :legal_move? ).and_return( true )
      expect( subject ).to receive( :empty_space? ).and_return( false )
      expect( subject ).to receive( :different_team? ).and_return( false )
      expect( subject ).to_not receive( :convert_to_file_position )
      expect( subject ).to_not receive( :convert_to_rank_position )
      subject.find_spaces_diagonally_bottom_right( 4, 3, piece )
    end
  end
end