# frozen_string_literal: true

module ModuleFiller
  PIXELS_PER_MODULE = 3

  def fill_vqr_module(x_index, y_index)
    if @common_patterns[x_index][y_index].nil?
      fill_vqr_module_with_image(x_index, y_index)
      fill_vqr_module_with_basic_qrcode(x_index, y_index)
    else
      fill_vqr_module_with_pattern(x_index, y_index)
    end
  end

  protected

  def fill_vqr_module_with_basic_qrcode(x_index, y_index)
    multiplied_range_each(x_index, y_index) do |new_x, new_y, x_offset, y_offset|
      if central_pixel?(x_offset, y_offset) || @image_handler.pixels[new_x][new_y][3].zero?
        value = @basic_qrcode.modules[x_index][y_index]
        @vqr_pixels[new_x][new_y] = pixel_of(value)
      end
    end
  end

  def fill_vqr_module_with_image(x_index, y_index)
    multiplied_range_each(x_index, y_index) do |new_x, new_y, x_offset, y_offset|
      next if central_pixel?(x_offset, y_offset)

      pixel = @image_handler.pixels[new_x][new_y]
      @vqr_pixels[new_x][new_y] = pixel
    end
  end

  def fill_vqr_module_with_pattern(x_index, y_index)
    multiplied_range_each(x_index, y_index) do |new_x, new_y|
      value = @common_patterns[x_index][y_index]
      @vqr_pixels[new_x][new_y] = pixel_of(value)
    end
  end

  def multiplied_range_each(x_index, y_index, &block)
    module_range.each do |x_offset|
      module_range.each do |y_offset|
        new_x = (PIXELS_PER_MODULE * x_index * size_multiplier) + x_offset
        new_y = (PIXELS_PER_MODULE * y_index * size_multiplier) + y_offset
        block.call(new_x, new_y, x_offset, y_offset)
      end
    end
  end

  def module_size
    @module_size ||= PIXELS_PER_MODULE * size_multiplier
  end

  # [0, 1, 2] : all pixels of a module
  def module_range
    @module_range ||= 0..(module_size - 1)
  end

  # 1 : the central pixels of a module
  def central_range
    @central_range ||= begin
      third_of_range = module_range.max / 3
      (third_of_range + 1)..((third_of_range * 2) + 1)
    end
  end

  def central_pixel?(x_offset, y_offset)
    central_range.include?(x_offset) && central_range.include?(y_offset)
  end
end
