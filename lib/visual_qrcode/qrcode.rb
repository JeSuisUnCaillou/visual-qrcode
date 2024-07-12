# frozen_string_literal: true

require "rqrcode_core"
require_relative "pixels_handler"
require_relative "export"
require_relative "pixel_tools"
require_relative "module_filler"

module VisualQrcode
  class Qrcode
    include PixelTools
    include ModuleFiller

    DEFAULT_PADDING_MODULES = 7

    attr_reader :content, :basic_qrcode, :image_handler, :vqr_pixels

    def initialize(content, image_path, size: nil, padding_modules: nil, qr_size: nil)
      @content = content
      @size = size
      @padding_modules = padding_modules || DEFAULT_PADDING_MODULES
      @qr_size = qr_size || 6

      initialize_basic_qr_code_and_qr_size(content)
      @image_handler = VisualQrcode::PixelsHandler.new(image_path: image_path)
      @common_patterns = @basic_qrcode.instance_variable_get(:@common_patterns)
    end

    def as_png(margin: default_margin)
      make
      VisualQrcode::Export.new(@vqr_pixels).as_png(size: @size, margin: margin)
    end

    def make
      intit_vqr_pixels
      resize_image
      fill_vqr_pixels
    end

    def intit_vqr_pixels
      @vqr_length = min_length * size_multiplier
      @vqr_pixels = Array.new(@vqr_length) { Array.new(@vqr_length) }
    end

    def resize_image
      padding_size = @padding_modules * module_size
      @image_handler.resize_with_padding(@vqr_length, padding_size)
    end

    def fill_vqr_pixels
      @basic_qrcode.modules.each_with_index do |module_row, x_index|
        module_row.each_index do |y_index|
          fill_vqr_module(x_index, y_index)
        end
      end
    end

    private

    def initialize_basic_qr_code_and_qr_size(content)
      @basic_qrcode = RQRCodeCore::QRCode.new(content, level: :h, size: @qr_size)
    rescue RQRCodeCore::QRCodeRunTimeError => error
      if error.message =~ /^code length overflow./
        @qr_size = @qr_size + 1
        initialize_basic_qr_code_and_qr_size(content)
      else
        raise error
      end
    end

    def default_margin
      module_size * 2
    end

    def size_multiplier
      return 1 if @size.nil?
      raise "Minimum size for your content is #{min_length}px" if @size < min_length

      @size_multiplier ||= 1 + (@size / min_length)
    end

    def min_length
      @min_length ||= @basic_qrcode.modules.length * PIXELS_PER_MODULE
    end
  end
end
