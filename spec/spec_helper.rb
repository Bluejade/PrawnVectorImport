$LOAD_PATH << File.join(File.dirname(__FILE__),".." ,"lib" )
require 'spec'
require 'prawn_vector_import'

def path_to(file_name)
  File.join(".", "spec", "pdfs", file_name)
end
