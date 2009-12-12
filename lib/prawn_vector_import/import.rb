require 'rubygems'
require 'pdf/reader'

module PrawnVectorImport
  class Import
    attr_reader :line_count
    
    def initialize(file_path, method_name = "my_vector_graphics")
      @output = []
      @line_count = 0
      @deferred_block = []
      @method_name = method_name
      PDF::Reader.file(file_path, self)
    end
    
    def output
      @header = []
      @header << "module Prawn"
      @header << "  module Graphics"
      @header << "    # Change this method name to something that fits your graphics"
      @header << "    # ox and oy are offset_x and offset_y, respectively. they are used to position your graphics"
      @header << "    # os is the amount to scale the graphics"
      @header << "    def #@method_name(ox=0, oy=0, os=1)"
      @header << "      # Do not modify gsXs and gsYs. They handle translational graphics state saving/restoring"
      @header << "      gsXs = []"
      @header << "      gsYs = []"


      @footer = []
      @footer << "    end"
      @footer << "  end"
      @footer << "end"

      @header.join("\n") + "\n      " + @output.join("\n      ") + "\n" + @footer.join("\n")
    end

    def concatenate_matrix(*params)
      # only handling translational matrix at this point
      @output << "ox += #{params[4]} * os"
      @output << "oy += #{params[5]} * os"
    end

    def save_graphics_state
      # this should really save the entire graphics state, but at this
      # point, I am only handling simple modifications, and
      # Illustrator seems use concatenate_matrix and graphics state
      # saving and restoring around various objects
      @output << "gsXs << ox"
      @output << "gsYs << oy"
    end

    def restore_graphics_state
      @output << "ox = gsXs.pop"
      @output << "oy = gsYs.pop"
    end

    def discard_deferred_block
      # don't draw things like clipping paths
      @deferred_block = []
    end

    alias_method :set_clipping_path_with_nonzero, :discard_deferred_block
    alias_method :set_clipping_path_with_even_odd, :discard_deferred_block
    
    def stroke
      @output << "stroke do"
      @output << "  " + @deferred_block.join("\n        ")
      @output << "end"
      @deferred_block = []
    end
    
    def fill_stroke
      @output << "fill_and_stroke do"
      @output << "  " + @deferred_block.join("\n        ")
      @output << "end"
      @deferred_block = []
    end
    
    def fill
      @output << "fill do"
      @output << "  " + @deferred_block.join("\n        ")
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
      @deferred_block << "rectangle([os * #{x} + ox, os * #{y + height} + oy], os * #{width}, os * #{height})"
    end

    def append_curved_segment(*params)
      @deferred_block << "curve_to([os * #{params[4]} + ox, os * #{params[5]} + oy], :bounds => [[os * #{params[0]} + ox, os * #{params[1]} + oy], [os * #{params[2]} + ox, os * #{params[3]} + oy]])"
    end


    def set_rgb_color_for_stroking(*params)
      r = params[0]
      g = params[1]
      b = params[2]
      @output << "stroke_color(rgb2hex([#{r} * 255, #{g} * 255, #{b} * 255]))"
    end

    def set_rgb_color_for_nonstroking(*params)
      r = params[0]
      g = params[1]
      b = params[2]
      @output << "fill_color(rgb2hex([#{r} * 255, #{g} * 255, #{b} * 255]))"
    end
    
    def set_cmyk_color_for_stroking(*params)
      c = params[0]
      m = params[1]
      y = params[2]
      k = params[3]
      @output << "stroke_color(#{c}, #{m}, #{y}, #{k})"
    end

    def set_cmyk_color_for_nonstroking(*params)
      params = params.map { |x| x * 100 }
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
      space = array[1] || "nil"
      phase = params[1] || "nil"
      @output << "dash(#{length}, :space => #{space}, :phase => #{phase})"
    end
    
    private

  end
end
