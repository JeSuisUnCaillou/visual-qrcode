# frozen_string_literal: true

RSpec.describe VisualQrcode::Test do
  let(:input) { "tatatoto" }
  it "does the thing" do
    expect(VisualQrcode::Test.new(input).input).to eq(input)
  end
end
