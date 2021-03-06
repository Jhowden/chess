$LOAD_PATH.unshift( File.expand_path( File.join( File.dirname( __FILE__ ), "..", "lib", "helpers" ) ) )
require "excluded_file_partial"

Dir[File.expand_path( File.join( File.dirname( __FILE__ ), '*.rb' ) )].each do |file|
  require file unless file =~ ExcludedFilePartial::FILE_PATH_PARTIAL
end

board = Board.new
game = Game.new( board )
game.play!