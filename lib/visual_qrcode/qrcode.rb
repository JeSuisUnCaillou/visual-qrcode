# frozen_string_literal: true

require "rqrcode_core"
require_relative "image_handler"
require_relative "export"
require_relative "pixel_tools"

module VisualQrcode
  class Qrcode
    include PixelTools

    SIZE_MULTIPLIER = 3
    PADDING_MODULES = 6

    attr_reader :content, :basic_qrcode

    def initialize(content, image_path)
      @content = content
      @image_handler = VisualQrcode::ImageHandler.new(image_path)
      @basic_qrcode = RQRCodeCore::QRCode.new(content, level: :h)
      @common_patterns = @basic_qrcode.instance_variable_get(:@common_patterns)
    end

    def make
      intit_vqr_pixels
      resize_image
      fill_vqr_pixels
    end

    def intit_vqr_pixels
      basic_length = @basic_qrcode.modules.length
      @vqr_length = basic_length * SIZE_MULTIPLIER
      @vqr_pixels = Array.new @vqr_length
      @vqr_pixels.each_index { |i| @vqr_pixels[i] = Array.new @vqr_length }
    end

    def resize_image
      padding_size = PADDING_MODULES * SIZE_MULTIPLIER
      @image_handler.resize(@vqr_length, padding_size)
    end

    def fill_vqr_pixels
      @basic_qrcode.modules.each_with_index do |module_row, x_index|
        module_row.each_index do |y_index|
          fill_vqr_pixel(x_index, y_index)
        end
      end
      @vqr_pixels
    end

    def as_png
      VisualQrcode::Export.new(@vqr_pixels).as_png(@vqr_length, @vqr_length)
    end

    def basic_qrcode_as_png
      basic_qrcode_pixels = @basic_qrcode.modules.map do |module_row|
        pixels_row = module_row.map { |value| [pixel_of(value)] * SIZE_MULTIPLIER }.flatten
        ([pixels_row] * SIZE_MULTIPLIER)
      end.flatten(1)

      VisualQrcode::Export.new(basic_qrcode_pixels).as_png(basic_qrcode_pixels.length, basic_qrcode_pixels.length)
    end

    private

    def fill_vqr_pixel(x_index, y_index)
      if @common_patterns[x_index][y_index].nil?
        fill_vqr_pixels_with_image(x_index, y_index)
        fill_vqr_pixels_with_basic_qrcode(x_index, y_index)
      else
        fill_vqr_pixels_with_pattern(x_index, y_index)
      end
    end

    def fill_vqr_pixels_with_basic_qrcode(x_index, y_index)
      multiplied_range_each(x_index, y_index) do |new_x, new_y, x_offset, y_offset|
        if central_offset?(x_offset, y_offset) || @image_handler.pixels[new_x][new_y][3].zero?
          value = @basic_qrcode.modules[x_index][y_index]
          @vqr_pixels[new_x][new_y] = pixel_of(value)
        end
      end
    end

    def fill_vqr_pixels_with_image(x_index, y_index)
      multiplied_range_each(x_index, y_index) do |new_x, new_y, x_offset, y_offset|
        next if central_offset?(x_offset, y_offset)

        pixel = @image_handler.pixels[new_x][new_y]
        @vqr_pixels[new_x][new_y] = pixel
      end
    end

    def fill_vqr_pixels_with_pattern(x_index, y_index)
      multiplied_range_each(x_index, y_index) do |new_x, new_y|
        value = @common_patterns[x_index][y_index]
        @vqr_pixels[new_x][new_y] = pixel_of(value)
      end
    end

    def multiplied_range_each(x_index, y_index, &block)
      multiplied_range.each do |x_offset|
        multiplied_range.each do |y_offset|
          new_x = (SIZE_MULTIPLIER * x_index) + x_offset
          new_y = (SIZE_MULTIPLIER * y_index) + y_offset
          block.call(new_x, new_y, x_offset, y_offset)
        end
      end
    end

    # [0, 1, 2] : all pixels
    def multiplied_range
      0..(SIZE_MULTIPLIER - 1)
    end

    # 1 : only the central pixel
    def central_offset
      @central_offset ||= 1
    end

    def central_offset?(x_offset, y_offset)
      x_offset == central_offset && y_offset == central_offset
    end
  end
end
