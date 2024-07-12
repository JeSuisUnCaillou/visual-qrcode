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
end
