FILE_PATH_PARTIAL = /lib\/play_game.rb/
Dir[File.expand_path( File.join( File.dirname( __FILE__ ), "..", "lib", "*.rb" ) )].each do |file|
  require file unless file =~ FILE_PATH_PARTIAL
end