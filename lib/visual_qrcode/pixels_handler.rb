# frozen_string_literal: true

require "mini_magick"
require_relative "pixel_tools"

module VisualQrcode
  class PixelsHandler
    include PixelTools

    attr_accessor :pixels

    def initialize(pixels: nil, image_path: nil)
      if pixels
        @pixels = pixels
      else
        @image = MiniMagick::Image.open(image_path)
        set_pixels_from_image
      end
    end

    def size
      @pixels.length
    end

    def dimensions
      [size] * 2
    end

    def resize_with_padding(new_size, padding)
      padded_size = new_size - (2 * padding)
      resize(padded_size)
      add_margin(padding)
    end

    def resize(new_size)
      image.resize "#{new_size}x#{new_size}"
      set_pixels_from_image
      make_square
    end

    def add_margin(margin, color: :transparent)
      pixel = pixel_of_color(color)
      row_margin = [pixel] * margin
      col_margin = [Array.new(size + (2 * margin), pixel)] * margin

      margined_rows = @pixels.map do |row|
        row_margin + row + row_margin
      end

      @pixels = col_margin + margined_rows + col_margin
    end

    def make_square
      max_size = [@pixels.length, @pixels.first.length].max

      if @pixels.length < max_size
        add_transparent_columns_to_size(max_size)
      elsif @pixels.first.length < max_size
        add_transparent_rows_to_size(max_size)
      end
    end

    private

    def add_transparent_columns_to_size(max_size)
      size_difference = max_size - @pixels.length
      margin = size_difference / 2
      rest_of_margin = size_difference % 2

      left_col_margin = [Array.new(max_size, transparent_pixel)] * margin
      right_col_margin = [Array.new(max_size, transparent_pixel)] * (margin + rest_of_margin)

      @pixels = left_col_margin + @pixels + right_col_margin
    end

    def add_transparent_rows_to_size(max_size)
      size_difference = max_size - @pixels.first.length
      margin = size_difference / 2
      rest_of_margin = size_difference % 2

      left_row_margin = [transparent_pixel] * margin
      right_row_margin = [transparent_pixel] * (margin + rest_of_margin)

      @pixels = @pixels.map do |row|
        left_row_margin + row + right_row_margin
      end
    end

    def set_pixels_from_image
      @pixels = @image.get_pixels("RGBA")
    end

    def image
      @image ||= MiniMagick::Image.get_image_from_pixels(@pixels, [size, size], "RGBA", PIXEL_DEPTH, "png")
    end
  end
end
