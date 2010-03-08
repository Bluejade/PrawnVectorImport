require File.join(File.dirname(__FILE__), '..' ,'spec_helper' )

module PrawnVectorImport
  describe Import do
    it 'should be able to import a file' do
      import = PrawnVectorImport::Import.new(path_to('stroke_dash.pdf'), 'my_vector_graphics')
      import.line_count.should == 101
    end
    
    it 'should be able to import lines' do
      import = PrawnVectorImport::Import.new(path_to('stroke_dash.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*move_to\([0-9.-]+, [0-9.-]+\)$.^\s*line_to\([0-9.-]+, [0-9.-]+\)/m
    end
    
    it 'should be able to import curves' do
      import = PrawnVectorImport::Import.new(path_to('text_oval.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*move_to\([0-9.-]+, [0-9.-]+\)$.^\s*curve_to\(\[[0-9.-]+, [0-9.-]+\], :bounds => \[\[[0-9.-]+, [0-9.-]+\], \[[0-9.-]+, [0-9.-]+\]\]\)/m
    end
    
    it 'should be able to draw a rectangle' do
      import = PrawnVectorImport::Import.new(path_to('pretty_polygons.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*rectangle\(\[[0-9.-]+, [0-9.-]+\], [0-9.]+, [0-9.]+\)$/
    end

    it 'should be able to fill' do
      import = PrawnVectorImport::Import.new(path_to('curves.pdf'), 'my_vector_graphics')
      import.output.should =~ /fill do/
    end
    
    it 'should be able to stroke' do
      import = PrawnVectorImport::Import.new(path_to('text_oval.pdf'), 'my_vector_graphics')
      import.output.should =~ /stroke do/
    end
    
    it 'should be able to fill and stroke' do
      import = PrawnVectorImport::Import.new(path_to('curves.pdf'), 'my_vector_graphics')
      import.output.should =~ /fill_and_stroke do/
    end

    it 'should be able to set fill color' do
      import = PrawnVectorImport::Import.new(path_to('curves.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*fill_color\(rgb2hex\(\[[0-9.]+ \* 255, [0-9.]+ \* 255, [0-9.]+ \* 255\]\)\)$/
    end
    
    it 'should be able to set stroke color' do
      import = PrawnVectorImport::Import.new(path_to('curves.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*stroke_color\(rgb2hex\(\[[0-9.]+ \* 255, [0-9.]+ \* 255, [0-9.]+ \* 255\]\)\)$/
    end
    
    it 'should be able to set stroke width' do
      import = PrawnVectorImport::Import.new(path_to('lines.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*line_width\([0-9.]+\)$/
    end
    
    it 'should be able to import dash setting' do
      import = PrawnVectorImport::Import.new(path_to('stroke_dash.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*dash\([0-9.-]+, :space => [0-9.]+, :phase => [0-9.]+\)$/
    end
    
    it 'should be able to undash' do
      import = PrawnVectorImport::Import.new(path_to('stroke_dash.pdf'), 'my_vector_graphics')
      import.output.should =~ /^\s*undash$/
    end
  end
end
