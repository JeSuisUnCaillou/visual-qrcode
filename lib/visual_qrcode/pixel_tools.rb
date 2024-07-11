# frozen_string_literal: true

module PixelTools
  PIXEL_DEPTH = 8

  def max_depth
    @max_depth ||= (2**PIXEL_DEPTH) - 1
  end

  def pixel_of(value)
    pixel_value = value ? 0 : max_depth
    [pixel_value, pixel_value, pixel_value, max_depth]
  end
end
