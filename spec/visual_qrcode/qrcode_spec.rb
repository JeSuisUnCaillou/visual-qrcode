# frozen_string_literal: true

require "mini_magick"

RSpec.describe VisualQrcode::Qrcode do
  subject(:visual_qrcode) { described_class.new(text, image_path) }

  let(:text) { "Taataaaa Yoyoyooooo ! Qu'est-ce que tu caches sous ton grand chapeauuuuuu !" }
  let(:image_name) { "marianne" }
  let(:image_path) { "spec/images/#{image_name}.png" }

  it "exposes a basic qrcode" do
    expect(visual_qrcode.basic_qrcode).to be_a RQRCodeCore::QRCode
  end

  describe "#intit_vqr_pixels" do
    subject(:intit_vqr_pixels) { visual_qrcode.intit_vqr_pixels }

    it "initializes a table 3 times larger than the basic qr_code modules" do
      expect(intit_vqr_pixels.length).to eq visual_qrcode.basic_qrcode.modules.length * 3
    end
  end

  describe "#fill_vqr_pixels" do
    subject(:fill_vqr_pixels) { visual_qrcode.fill_vqr_pixels }

    before do
      visual_qrcode.intit_vqr_pixels
      visual_qrcode.resize_image
    end

    it "fills the vqr_pixels until the last row" do
      expect(fill_vqr_pixels.last.uniq).not_to eq [nil]
    end
  end

  describe "export tests" do
    subject(:export) do
      visual_qrcode.make
      visual_qrcode.basic_qrcode_as_png.write(basic_qrcode_path)
      visual_qrcode.as_png.write(visual_qrcode_path)
    end

    let(:basic_qrcode_path) { "spec/images/#{image_name}_basic_qrcode.png" }
    let(:visual_qrcode_path) { "spec/images/#{image_name}_visual_qrcode.png" }

    it "generates a basic qr code" do
      expect { export }.to(change { File.mtime(basic_qrcode_path) })
    end

    it "generates a visual qr code" do
      expect { export }.to(change { File.mtime(visual_qrcode_path) })
    end
  end
end
