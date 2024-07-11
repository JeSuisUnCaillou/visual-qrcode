# frozen_string_literal: true

require_relative "visual_qrcode/version"
require_relative "visual_qrcode/qrcode"

module VisualQrcode
  PIXEL_DEPTH = 8
  class Error < StandardError; end
end
