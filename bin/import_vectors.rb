$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'prawn_vector_import'

if ARGV[0].blank? || ARGV[1].blank?
  puts 'Usage: ruby bin/import_vectors.rb path_to_ai_or_pdf_file method_name > method_name.rb'
end
import = PrawnVectorImport::Import.new(ARGV[0], ARGV[1])
puts import.output
