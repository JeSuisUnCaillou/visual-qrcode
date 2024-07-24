# frozen_string_literal: true

RSpec.describe VisualQrcode::PixelsHandler do
  subject(:pixels_handler) { described_class.new(image_path: image_path) }

  let(:image_name) { "marianne" }
  let(:image_path) { "spec/images/#{image_name}.png" }

  it "exposes the image's pixels" do
    expect(pixels_handler.pixels.length).to eq 480
  end

  describe "#add_margin" do
    subject(:add_margin) { pixels_handler.add_margin(padding) }

    let(:padding) { 3 }

    it "adds a margin around the pixels" do
      expect { add_margin }
        .to change { pixels_handler.pixels.length }.by(padding * 2)
        .and change { pixels_handler.pixels.first.length }.by(padding * 2)
    end
  end

  describe "#resize" do
    subject(:resize) { pixels_handler.resize(new_size) }

    let(:new_size) { 100 }

    it "resizes the pixels matrix" do
      expect { resize }
        .to change { pixels_handler.pixels.length }.to(new_size)
        .and change { pixels_handler.pixels.first.length }.to(new_size)
    end

    context "with a horizontal rectangle image" do
      let(:image_name) { "horizontal_rectangle" }

      it "completes pixels with columns of transparency" do
        expect { resize }
          .to change { pixels_handler.pixels.length }.to(new_size)
          .and change { pixels_handler.pixels.first.length }.to(new_size)
      end
    end

    context "with a vertical rectangle image" do
      let(:image_name) { "vertical_rectangle" }

      it "completes pixels with rows of transparency" do
        expect { resize }
          .to change { pixels_handler.pixels.length }.to(new_size)
          .and change { pixels_handler.pixels.first.length }.to(new_size)
      end
    end
  end
end
