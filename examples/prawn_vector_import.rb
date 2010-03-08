# encoding: utf-8
#

require "#{File.dirname(__FILE__)}/example_helper.rb"
require "#{File.dirname(__FILE__)}/my_vector_graphics"

pdf = Prawn::Document.new

pdf.translate(175, 270) do
  pdf.my_vector_graphics
end

pdf.render_file("prawn_vector_import.pdf")

