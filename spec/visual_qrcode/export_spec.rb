# frozen_string_literal: true

RSpec.describe VisualQrcode::Export do
  subject(:export) { described_class.new(pixels) }

  let(:pixels) { [[[255, 255, 255, 255]]] }

  describe "#as_png" do
    subject(:as_png) { export.as_png }

    it "creates a png of the visual qrcode" do
      expect(as_png).to be_a MiniMagick::Image
    end
  end

  describe "write files" do
    subject(:write_file) do
      visual_qrcode.as_png.write(qrcode_path)
    end

    let(:image_path) { "spec/images/#{image_name}.png" }
    let(:qrcode_path) { "spec/images/#{image_name}_visual_qrcode.png" }
    let(:size) { nil }
    let(:padding_modules) { nil }
    let(:minimum_qr_size) { nil }
    let(:basic_modules_lenth) { visual_qrcode.basic_qrcode.modules.length }
    let(:visual_qrcode) do
      VisualQrcode::Qrcode.new(
        text,
        image_path,
        size: size,
        padding_modules: padding_modules,
        minimum_qr_size: minimum_qr_size
      )
    end

    context "with the ruby and a size" do
      let(:image_name) { "ruby" }
      let(:text) { "https://www.ruby-lang.org/" }
      let(:size) { 260 }

      it "generates a visual qr code of ruby" do
        expect { write_file }.to(change { File.mtime(qrcode_path) })
      end
    end

    context "with the marianne, a size and a minimum_qr_size" do
      let(:image_name) { "marianne" }
      let(:text) { "https://www.service-public.fr/" }
      let(:size) { 260 }
      let(:minimum_qr_size) { 10 }

      it "generates a visual qr code of marianne" do
        expect { write_file }.to(change { File.mtime(qrcode_path) })
      end
    end

    context "with the zidane, a size, a minimum_qr_size and padding modules" do
      let(:image_name) { "zidane" }
      let(:text) { "https://en.wikipedia.org/wiki/Zinedine_Zidane" }
      let(:padding_modules) { 0 }
      let(:minimum_qr_size) { 15 }
      let(:size) { 260 }

      it "generates a visual qr code of zidane" do
        expect { write_file }.to(change { File.mtime(qrcode_path) })
      end
    end

    context "with a rectangle image" do
      let(:image_name) { "horizontal_rectangle" }
      let(:text) { "https://www.pngmart.com/files/4/Colorful-PNG-Transparent-Picture.png" }

      it "generates a visual qr code of the rectangle" do
        expect { write_file }.to(change { File.mtime(qrcode_path) })
      end
    end
  end
end
