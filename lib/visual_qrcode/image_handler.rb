# frozen_string_literal: true

require "mini_magick"

module VisualQrcode
  class ImageHandler
    attr_accessor :image, :pixels

    def initialize(image_path)
      @image = MiniMagick::Image.open(image_path)
    end

    def resize(size, padding)
      padded_size = size - (2 * padding)
      @image.resize "#{padded_size}x#{padded_size}"
      @pixels = @image.get_pixels("RGBA")
      add_padding_to_pixels(size, padding)
    end

    def add_padding_to_pixels(size, padding)
      row_padding = [transparent_pixel] * padding
      col_padding = [Array.new(size, transparent_pixel)] * padding

      padded_rows = @pixels.map do |row|
        row_padding + row + row_padding
      end

      @pixels = col_padding + padded_rows + col_padding
    end

    def transparent_pixel
      @transparent_pixel ||= [0, 0, 0, 0]
    end
  end
end
