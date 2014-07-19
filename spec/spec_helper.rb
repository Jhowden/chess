require_relative "../lib/helpers/excluded_file_partial"

Dir[File.expand_path( File.join( File.dirname( __FILE__ ), "..", "lib", "*.rb" ) )].each do |file|
  require file unless file =~ ExcludedFilePartial::FILE_PATH_PARTIAL
end