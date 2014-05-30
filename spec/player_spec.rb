require "spec_helper"

describe Player do 

  let( :player ) { described_class.new( :white ) }
  let( :piece ) { double() }
  let( :piece2 ) { double() }

  before(:each) do
    allow( piece2 ).to receive( :is_a? ).and_return true
  end

  it "returns a players team" do
    expect( player.team ).to eq( :white )
  end

  it "sets the pieces for the player" do
    player.set_team_pieces( [piece] )
    expect( player.team_pieces.size ).to eq( 1 )
  end

  it "finds the player's king piece" do
    player.set_team_pieces( [piece, piece2] )
    player.find_king_piece
    expect( player.king_piece ).to_not be_nil
  end
end