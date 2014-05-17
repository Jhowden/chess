require "spec_helper"

describe Player do 

  let( :player ) { described_class.new( :white ) }

  it "returns a players team" do
    expect( player.team ).to eq( :white )
  end
end