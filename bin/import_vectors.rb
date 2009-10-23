$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'prawn_vector_import'

import = PrawnVectorImport::Import.new(ARGV[0])
puts import.output
