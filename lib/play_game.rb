Dir[File.expand_path( File.join( File.dirname( __FILE__ ), '*.rb' ) )].each do |file|
  require file
end

board = Board.new
game = Game.new( board )
game.play!