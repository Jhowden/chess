# Why not use '*' to require everything in lib?
Dir[File.expand_path( File.join( File.dirname( __FILE__ ), "..", "lib", "*.rb" ) )].each do |file|
  require file unless file == "/Users/jonathanhowden/Desktop/chess/lib/play_game.rb"
end