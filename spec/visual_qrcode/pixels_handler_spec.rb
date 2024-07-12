# frozen_string_literal: true

RSpec.describe VisualQrcode::PixelsHandler do
  subject(:image_handler) { described_class.new(image_path: image_path) }

  let(:image_name) { "marianne" }
  let(:image_path) { "spec/images/#{image_name}.png" }
  let(:image_size) { 480 }

  it "exposes the image's pixels" do
    expect(image_handler.pixels.length).to eq image_size
  end

  describe "#add_margin" do
    subject(:add_margin) { image_handler.add_margin(padding) }

    let(:padding) { 3 }

    it "adds a margin around the pixels" do
      expect { add_margin }
        .to change { image_handler.pixels.length }.by(padding * 2)
        .and change { image_handler.pixels.first.length }.by(padding * 2)
    end
  end

  describe "#resize" do
    subject(:resize) { image_handler.resize(new_size) }

    let(:new_size) { 10 }

    it "resizes the pixels matrix" do
      expect { resize }
        .to change { image_handler.pixels.length }.to(new_size)
        .and change { image_handler.pixels.first.length }.to(new_size)
    end
  end
end
