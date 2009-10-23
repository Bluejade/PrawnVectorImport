require 'rubygems'
require 'pdf/reader'

module PrawnVectorImport
  class Import
    attr_reader :line_count
    
    def initialize(file_path)
      #       puts Dir.getwd
      #       puts file_path
      @output = []
      # ox and oy define the origin offset, so one can adjust the
      # position of the imported graphics without returning to the
      # program that generated the graphics
      @output << "ox = 0"
      @output << "oy = 0"
      # os is the origin scale, so the graphics can be scaled without
      # program that generated the graphics
      @output << "os = 1"
      @output << ""
      @line_count = 0
      @deferred_block = []
      PDF::Reader.file(file_path, self)
    end
    
    def output
      @output.join("\n")
    end
    
    def stroke
      @output << "stroke do"
      @output << @deferred_block.join("\n")
      @output << "end"
      @deferred_block = []
    end
    
    def fill_stroke
      @output << "fill_and_stroke do"
      @output << @deferred_block.join("\n")
      @output << "end"
      @deferred_block = []
    end
    
    def fill
      @output << "fill do"
      @output << @deferred_block.join("\n")
      @output << "end"
      @deferred_block = []
    end

    alias_method :stroke_path, :stroke
    alias_method :fill_path_with_nonzero, :fill
    
    # close_ prefixed methods should treat the last and first points as if
    # they are joined
    alias_method :close_and_stroke_path, :stroke
    alias_method :close_fill_stroke, :fill_stroke

    # deal with even odd later
    alias_method :fill_path_with_even_odd, :fill
    alias_method :fill_stroke_with_even_odd, :fill_stroke
    alias_method :close_fill_stroke_with_even_odd, :fill_stroke
    

    def begin_new_subpath(*point)
      @deferred_block << "move_to(os * #{point[0]} + ox, os * #{point[1]} + oy)"
    end

    def append_line(*point)
      @line_count += 1
      @deferred_block << "line_to(os * #{point[0]} + ox, os * #{point[1]} + oy)"
    end

    def append_rectangle(*params)
      x = params[0]
      y = params[1]
      width = params[2]
      height = params[3]
      @deferred_block << "rectangle([os * #{x} + ox, os * #{y + height} + oy], #{width}, #{height})"
    end

    def append_curved_segment(*params)
      @deferred_block << "curve_to([os * #{params[4]} + ox, os * #{params[5]} + oy], :bounds => [#{params[0]}, #{params[1]}, #{params[2]}, #{params[3]}])"
    end


    def set_rgb_color_for_stroking(*params)
      r = params[0]
      g = params[1]
      b = params[2]
      @output << "stroke_color(rgb2hex([#{r}, #{g}, #{b}]))"
    end

    def set_rgb_color_for_nonstroking(*params)
      r = params[0]
      g = params[1]
      b = params[2]
      @output << "fill_color(rgb2hex([#{r}, #{g}, #{b}]))"
    end
    
    def set_cmyk_color_for_stroking(params)
      c = params[0]
      m = params[1]
      y = params[2]
      k = params[3]
      @output << "stroke_color(#{c}, #{m}, #{y}, #{k})"
    end

    def set_cmyk_color_for_nonstroking(params)
      c = params[0]
      m = params[1]
      y = params[2]
      k = params[3]
      @output << "fill_color(#{c}, #{m}, #{y}, #{k})"
    end

    def set_line_width(width)
      @output << "line_width(#{width})"
    end

    def set_line_dash(*params)
      array = params[0]
      if array.length == 0
        @output << "undash"
        return
      end
      length = array[0]
      space = array[1]
      phase = params[1]
      @output << "dash(#{length}, :space => #{space}, :phase => #{phase})"
    end
    
    private

  end
end
