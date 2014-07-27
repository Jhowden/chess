module Finished
  def finished?
    [player1, player2].any? { |player| player.checkmate? }
  end
  
  def winner
    winner = [player1, player2].reject { |player| player.checkmate? }
    puts "#{winner.first.team.capitalize} team is the winner!"
  end
end