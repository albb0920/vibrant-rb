require "spec_helper"
require 'vibrant'

describe Vibrant::VERSION do
  it '0.1.2' do
    expect(Vibrant::VERSION).to eq '0.1.2'
  end
end

describe Vibrant do

  describe Vibrant do

    it "png" do
      swatches = Vibrant.read('images/octocat.png')
      expect(swatches.vibrant.hex).to eq '#BA272A'
      expect(swatches.muted.hex).to eq '#AE5D52'
      expect(swatches.dark_vibrant.hex).to eq '#6F3C1C'
      expect(swatches.dark_muted.hex).to eq '#251F1A'
      expect(swatches.light_vibrant.hex).to eq '#9CDCF4'
      expect(swatches.light_muted.hex).to eq '#D2C2BA'
    end

    it "jpg" do
      vibrant = Vibrant::Vibrant.new('images/3.jpg')
      swatches = vibrant.swatches
      expect(swatches.vibrant.hex).to eq '#C73F3D'
      expect(swatches.muted.hex).to eq '#9A6957'
      expect(swatches.dark_vibrant.hex).to eq '#010606'
      expect(swatches.dark_muted.hex).to eq '#2F5649'
      expect(swatches.light_vibrant.hex).to eq '#E0B29A'
      expect(swatches.light_muted.hex).to eq '#D4C8B0'
    end

    it 'gif'

  end

end
