# frozen_string_literal: true

require "mini_magick"

RSpec.describe VisualQrcode::Qrcode do
  subject(:visual_qrcode) do
    described_class.new(
      text,
      image_path,
      size: size,
      padding_modules: padding_modules,
      qr_size: qr_size
    )
  end

  let(:text) { "Taataaaa Yoyoyooooo ! Qu'est-ce que tu caches sous ton grand chapeauuuuuu !" }
  let(:image_name) { "marianne" }
  let(:image_path) { "spec/images/#{image_name}.png" }
  let(:size) { nil }
  let(:padding_modules) { nil }
  let(:qr_size) { nil }
  let(:basic_modules_lenth) { visual_qrcode.basic_qrcode.modules.length }

  it "exposes a basic qrcode" do
    expect(visual_qrcode.basic_qrcode).to be_a RQRCodeCore::QRCode
  end

  describe "#intit_vqr_pixels" do
    subject(:intit_vqr_pixels) { visual_qrcode.intit_vqr_pixels }

    it "initializes a table 3 times larger than the basic qr_code modules" do
      expect(intit_vqr_pixels.length).to eq basic_modules_lenth * 3
    end

    context "with a size parameter too small" do
      let(:size) { 10 }

      it "raises an error explaining the minimum size possible" do
        expect { intit_vqr_pixels.length }.to raise_error "Minimum size for your content is 147px"
      end
    end

    context "with a size parameter at twice larger than minimum" do
      let(:size) { 150 }

      it "initializes a table 6 times larger than the basic qr_code modules" do
        expect(intit_vqr_pixels.length).to eq basic_modules_lenth * 6
      end
    end

    context "with a size parameter at least 3 times larger than minimum" do
      let(:size) { 300 }

      it "initializes a table 9 times larger than the basic qr_code modules" do
        expect(intit_vqr_pixels.length).to eq basic_modules_lenth * 9
      end
    end
  end

  describe "#resize_image" do
    subject(:resize_image) { visual_qrcode.resize_image }

    before do
      visual_qrcode.intit_vqr_pixels
    end

    it "resizes the image 3 times larger than the basic qr_code modules" do
      expect { resize_image }.to change { visual_qrcode.pixels_handler.size }.to basic_modules_lenth * 3
    end

    context "with a size parameter at least 3 times larger than minimum" do
      let(:size) { 300 }

      it "resizes the image 9 times larger than the basic qr_code modules" do
        expect { resize_image }.to change { visual_qrcode.pixels_handler.size }.to basic_modules_lenth * 9
      end
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

    context "with a size parameter at least 3 times larger than minimum" do
      let(:size) { 300 }

      it "fills the vqr_pixels up the last row" do
        expect { fill_vqr_pixels }.to(change { visual_qrcode.vqr_pixels.last })
      end
    end
  end

  describe "#fill_vqr_module" do
    subject(:fill_vqr_module) { visual_qrcode.fill_vqr_module(x, y) }

    before do
      visual_qrcode.intit_vqr_pixels
      visual_qrcode.resize_image
    end

    context "with the first module of the top left (common pattern)" do
      let(:x) { 0 }
      let(:y) { 0 }

      it "fills its corner pixel with black" do
        expect { fill_vqr_module }.to change { visual_qrcode.vqr_pixels[x * 3][y * 3] }.to [0, 0, 0, 255]
      end
    end

    context "with the 9th module on the first column (data)" do
      let(:x) { 8 }
      let(:y) { 0 }

      it "fills its central pixel with a white" do
        expect { fill_vqr_module }.to change { visual_qrcode.vqr_pixels[x * 3][y * 3] }.to [255, 255, 255, 255]
      end
    end

    context "with the 10th module on the first column (data)" do
      let(:x) { 9 }
      let(:y) { 0 }

      it "fills its central pixel with a black" do
        expect { fill_vqr_module }.to change { visual_qrcode.vqr_pixels[x * 3][y * 3] }.to [0, 0, 0, 255]
      end
    end

    # context "with the 9th module on the 9th column (image)" do
    #   let(:x) { 8 }
    #   let(:y) { 8 }

    #   it "fills it with a black" do
    #     expect { fill_vqr_module }.to change { visual_qrcode.vqr_pixels[x*3][y*3] }.to [0,0,0,255]
    #   end
    # end
  end

  describe "export tests" do
    subject(:export) do
      visual_qrcode.as_png.write(qrcode_path)
    end

    let(:qrcode_path) { "spec/images/#{image_name}_visual_qrcode.png" }

    context "with the marianne qr code and a size of 300" do
      let(:size) { 260 }

      it "generates a visual qr code of marianne" do
        expect { export }.to(change { File.mtime(qrcode_path) })
      end
    end

    context "with the ruby qr code and no padding modules" do
      let(:padding_modules) { 0 }
      let(:image_name) { "ruby" }
      let(:text) { "https://www.ruby-lang.org/" }
      let(:size) { 260 }

      it "generates a visual qr code of leaf" do
        expect { export }.to(change { File.mtime(qrcode_path) })
      end
    end

    context "with the zidane qr code with a qr_size" do
      let(:image_name) { "zidane" }
      let(:text) { "Allez zizou" }
      let(:qr_size) { 15 }
      let(:size) { 260 }

      it "generates a visual qr code of zidane" do
        expect { export }.to(change { File.mtime(qrcode_path) })
      end
    end
  end
end
