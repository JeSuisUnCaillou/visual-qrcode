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

    def resize_with_padding(new_size, padding)
      padded_size = new_size - (2 * padding)
      resize(padded_size)
      add_margin(padding)
    end

    def resize(new_size)
      image.resize "#{new_size}x#{new_size}"
      set_pixels_from_image
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

    private

    def set_pixels_from_image
      @pixels = @image.get_pixels("RGBA")
    end

    def image
      @image ||= MiniMagick::Image.get_image_from_pixels(@pixels, [size, size], "RGBA", PIXEL_DEPTH, "png")
    end
  end
end
