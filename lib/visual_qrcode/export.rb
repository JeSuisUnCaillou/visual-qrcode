# frozen_string_literal: true

require "mini_magick"
require_relative "pixel_tools"
require_relative "pixels_handler"

module VisualQrcode
  class Export
    include PixelTools

    def initialize(pixels)
      @pixels_handler = PixelsHandler.new(pixels: pixels)
    end

    def as_png(size: nil, margin: 6)
      @pixels_handler.add_margin(margin, color: :white)
      image = MiniMagick::Image.get_image_from_pixels(pixels, dimensions, "RGBA", PIXEL_DEPTH, "png")

      image.resize "#{size}x#{size}" if size

      image
    end

    def as_text(dark: "x", light: " ")
      pixels.map do |row|
        row.map do |pixel|
          is_light = pixel.nil? || pixel.sum < max_depth * 3
          is_light ? light : dark
        end.join
      end.join("\n")
    end

    def pixels
      @pixels_handler.pixels
    end

    def dimensions
      @pixels_handler.dimensions
    end
  end
end
