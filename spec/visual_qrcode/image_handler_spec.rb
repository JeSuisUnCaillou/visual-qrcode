# frozen_string_literal: true

RSpec.describe VisualQrcode::ImageHandler do
  subject(:image_handler) { described_class.new(image_path) }

  let(:image_name) { "marianne" }
  let(:image_path) { "spec/images/#{image_name}.png" }

  it "exposes the image" do
    expect(image_handler.image).to be_a MiniMagick::Image
  end
end
