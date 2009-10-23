require File.join(File.dirname(__FILE__), ".." ,"spec_helper" )

module PrawnVectorImport
  describe Import do
    it 'should be able to import a file' do
      import = PrawnVectorImport::Import.new(path_to("stroke_dash.pdf"))
      import.line_count.should == 101
    end
    
    it 'should be able to import lines' do
      import = PrawnVectorImport::Import.new(path_to("stroke_dash.pdf"))
      import.output.should =~ /^move_to\(os \* [0-9.-]+ \+ ox, os \* [0-9.-]+ \+ oy\)$.^line_to\(os \* [0-9.-]+ \+ ox, os \* [0-9.-]+ \+ oy\)/m
    end
    
    it 'should be able to import curves' do
      import = PrawnVectorImport::Import.new(path_to("text_oval.pdf"))
      import.output.should =~ /^move_to\(os \* [0-9.-]+ \+ ox, os \* [0-9.-]+ \+ oy\)$.^curve_to\(\[os \* [0-9.-]+ \+ ox, os \* [0-9.-]+ \+ oy\], :bounds => \[[0-9.-]+, [0-9.-]+, [0-9.-]+, [0-9.-]+\]\)/m
    end
    
    it 'should be able to draw a rectangle' do
      import = PrawnVectorImport::Import.new(path_to("pretty_polygons.pdf"))
      import.output.should =~ /^rectangle\(\[os \* [0-9.-]+ \+ ox, os \* [0-9.-]+ \+ oy\], [0-9.]+, [0-9.]+\)$/
    end

    it 'should be able to fill' do
      import = PrawnVectorImport::Import.new(path_to("curves.pdf"))
      import.output.should =~ /fill do/
    end
    
    it 'should be able to stroke' do
      import = PrawnVectorImport::Import.new(path_to("text_oval.pdf"))
      import.output.should =~ /stroke do/
    end
    
    it 'should be able to fill and stroke' do
      import = PrawnVectorImport::Import.new(path_to("curves.pdf"))
      import.output.should =~ /fill_and_stroke do/
    end

    it 'should be able to set fill color' do
      import = PrawnVectorImport::Import.new(path_to("curves.pdf"))
      import.output.should =~ /^fill_color\(rgb2hex\(\[[0-9.]+, [0-9.]+, [0-9.]+\]\)\)$/
    end
    
    it 'should be able to set stroke color' do
      import = PrawnVectorImport::Import.new(path_to("curves.pdf"))
      import.output.should =~ /^stroke_color\(rgb2hex\(\[[0-9.]+, [0-9.]+, [0-9.]+\]\)\)$/
    end
    
    it 'should be able to set stroke width' do
      import = PrawnVectorImport::Import.new(path_to("lines.pdf"))
      import.output.should =~ /^line_width\([0-9.]+\)$/
    end
    
    it 'should be able to import dash setting' do
      import = PrawnVectorImport::Import.new(path_to("stroke_dash.pdf"))
      import.output.should =~ /^dash\([0-9.-]+, :space => [0-9.]+, :phase => [0-9.]+\)$/
    end
    
    it 'should be able to undash' do
      import = PrawnVectorImport::Import.new(path_to("stroke_dash.pdf"))
      import.output.should =~ /^undash$/
    end
  end
end
