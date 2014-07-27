require "spec_helper"

describe Finished do
  class FakeClass
    
    attr_reader :player1, :player2
    def initialize( player1, player2 )
      @player1 = player1
      @player2 = player2
    end
  end
  
  let(:player1) { double() }
  let(:player2) { double() }
  let(:fake_class) { FakeClass.new( player1, player2 ).extend( described_class ) }
  
  describe "#finished?" do
    it "returns false when neither player is in checkmate" do
      allow( player1 ).to receive( :checkmate? ).and_return false
      allow( player2 ).to receive( :checkmate? ).and_return false
      expect( fake_class.finished? ).to be_false
    end
    
    it "returns true when at least one player is in checkmate" do
      allow( player1 ).to receive( :checkmate? ).and_return false
      allow( player2 ).to receive( :checkmate? ).and_return true
      expect( fake_class.finished? ).to be
    end
    
    it "checks to see if a player is in checkmate" do
      expect( player1 ).to receive( :checkmate? )
      expect( player2 ).to receive( :checkmate? )
      fake_class.finished? 
    end
  end
  
  describe "#winner" do
    it "returns the winner" do
      allow( STDOUT ).to receive( :puts )
      allow( player1 ).to receive( :checkmate? ).and_return false
      allow( player2 ).to receive( :checkmate? ).and_return true
      expect( player1 ).to receive( :team ).and_return :black
      fake_class.winner
    end
    
    it "displays the winner" do
      allow( player1 ).to receive( :checkmate? ).and_return true
      allow( player2 ).to receive( :checkmate? ).and_return false
      allow( player2 ).to receive( :team ).and_return :white
      expect( STDOUT ).to receive( :puts ).with( "White team is the winner!" )
      fake_class.winner
    end
  end
end