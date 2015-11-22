require "spec_helper"
require 'vibrant'



describe Vibrant do

  it Vibrant::VERSION do
    expect(Vibrant::VERSION).to eq '0.2.1'
  end

  describe '#read' do

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
      swatches = Vibrant.read('images/3.jpg')
      expect(swatches.vibrant.hex).to eq '#C73F3D'
      expect(swatches.muted.hex).to eq '#9A6957'
      expect(swatches.dark_vibrant.hex).to eq '#010606'
      expect(swatches.dark_muted.hex).to eq '#2F5649'
      expect(swatches.light_vibrant.hex).to eq '#E0B29A'
      expect(swatches.light_muted.hex).to eq '#D4C8B0'
    end

    it 'gif'

  end

  describe '#read , use_tempfile: true' do

    it "png" do
      swatches = Vibrant.read('images/octocat.png', use_tempfile: true)
      expect(swatches.vibrant.hex).to eq '#BA272A'
      expect(swatches.muted.hex).to eq '#AE5D52'
      expect(swatches.dark_vibrant.hex).to eq '#6F3C1C'
      expect(swatches.dark_muted.hex).to eq '#251F1A'
      expect(swatches.light_vibrant.hex).to eq '#9CDCF4'
      expect(swatches.light_muted.hex).to eq '#D2C2BA'
    end

    it "jpg" do
      swatches = Vibrant.read('images/3.jpg', use_tempfile: true)
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
