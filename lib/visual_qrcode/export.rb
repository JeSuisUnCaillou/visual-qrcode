# frozen_string_literal: true

require "mini_magick"

module VisualQrcode
  class Export
    def initialize(pixels)
      @pixels = pixels
    end

    def as_png(width, height)
      dimensions = [width, height]
      image = MiniMagick::Image.get_image_from_pixels(@pixels, dimensions, "RGBA", VisualQrcode::PIXEL_DEPTH, "png")
      image.resize dimensions.map { |d| d * 2 }.join("x")
    end
  end
end
