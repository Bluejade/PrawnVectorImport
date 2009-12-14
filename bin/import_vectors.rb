$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'prawn_vector_import'

if ARGV[0].nil? || ARGV[1].nil?
  puts "\nUsage: ruby bin/import_vectors.rb path_to_ai_or_pdf_file method_name > method_name.rb\n\n"
else
  import = PrawnVectorImport::Import.new(ARGV[0], ARGV[1])
  puts import.output
end
