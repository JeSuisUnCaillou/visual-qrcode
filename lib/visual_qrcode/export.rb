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

    def as_png(margin: 6)
      add_margin(margin)
      dimensions = [@pixels_handler.size] * 2
      image = MiniMagick::Image.get_image_from_pixels(pixels, dimensions, "RGBA", PIXEL_DEPTH, "png")
      image.resize dimensions.map { |d| d * 2 }.join("x")
    end

    def as_text(dark: "x", light: " ")
      pixels.map do |row|
        row.map do |pixel|
          is_light = pixel.nil? || pixel.sum < max_depth * 3
          is_light ? light : dark
        end.join
      end.join("\n")
    end

    def add_margin(margin)
      @pixels_handler.add_margin(margin, color: :white)
    end

    def pixels
      @pixels_handler.pixels
    end
  end
end
