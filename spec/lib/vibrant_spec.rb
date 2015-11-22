require "spec_helper"
require 'vibrant'

describe Vibrant::VERSION do
  it '0.1.2' do
    expect(Vibrant::VERSION).to eq '0.1.2'
  end
end

describe Vibrant::Vibrant do

  describe 'rgb2hsl' do

    it "png" do
      swatches = Vibrant.read('images/octocat.png')
      expect(swatches.vibrant.hex).to eq '#b92729'
      expect(swatches.muted.hex).to eq '#ae5d52'
      expect(swatches.dark_vibrant.hex).to eq '#6f3b1b'
      expect(swatches.dark_muted.hex).to eq '#5a3829'
      expect(swatches.light_vibrant.hex).to eq '#9bdbf3'
      expect(swatches.light_muted.hex).to eq '#d2c1b9'
    end

    it "jpg" do
      vibrant = Vibrant::Vibrant.new('images/3.jpg')
      swatches = vibrant.swatches
      expect(swatches.vibrant.hex).to eq '#c73f3d'
      expect(swatches.muted.hex).to eq '#9a6957'
      expect(swatches.dark_vibrant.hex).to eq '#032923'
      expect(swatches.dark_muted.hex).to eq '#2e5548'
      expect(swatches.light_vibrant.hex).to eq '#e0b299'
      expect(swatches.light_muted.hex).to eq '#d3c7b0'
    end
  end



  describe 'rgb2hsl' do 
    it 'white' do 
      expect(Vibrant.rgb2hsl(255,255,255)).to eq [0,0,1.0]
    end
    it 'black' do 
      expect(Vibrant.rgb2hsl(0,0,0)).to eq [0,0,0]
    end
    it 'red' do 
      expect(Vibrant.rgb2hsl(255,0,0)).to eq [0.0,1.0, 0.5]
    end
    it 'green' do 
      expect(Vibrant.rgb2hsl(0,255,0)).to eq [120.0/360.0,1.0,0.5]
    end
    it 'blue' do 
      expect(Vibrant.rgb2hsl(0,0,255)).to eq [240.0/360.0,1.0,0.5]
    end
  end
  
  describe 'hue2rgb'

  describe 'hsl2rgb'

end
