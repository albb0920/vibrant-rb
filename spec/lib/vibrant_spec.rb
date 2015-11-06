require "spec_helper"
require 'vibrant'

describe Vibrant::Vibrant do
  describe 'rgb2hsl' do
    it "is 3.jpeg" do
      vibrant = Vibrant::Vibrant.new('images/3.jpg')
      swatches = vibrant.swatches
      expect(swatches[:vibrant].hex).to eq '#c73f3d'
      expect(swatches[:muted].hex).to eq '#9a6957'
      expect(swatches[:dark_vibrant].hex).to eq '#032923'
      expect(swatches[:dark_muted].hex).to eq '#2e5548'
      expect(swatches[:light_vibrant].hex).to eq '#e0b299'
      expect(swatches[:light_muted]).to eq nil
    end
  end

  it "is octcat" do
    vibrant = Vibrant::Vibrant.new('images/octocat.png')
    swatches = vibrant.swatches
    expect(swatches[:vibrant].hex).to eq '#7a4426'
    expect(swatches[:muted].hex).to eq '#7b9eae'
    expect(swatches[:dark_vibrant].hex).to eq '#348945'
    expect(swatches[:dark_muted].hex).to eq '#141414'
    expect(swatches[:light_vibrant].hex).to eq '#f3ccb4'
    expect(swatches[:light_muted]).to eq nil
  end

  describe 'rgb2hsl' do 
    it 'white' do 
      expect(Vibrant::Vibrant.rgb2hsl(255,255,255)).to eq [0,0,1.0]
    end
    it 'black' do 
      expect(Vibrant::Vibrant.rgb2hsl(0,0,0)).to eq [0,0,0]
    end
    it 'red' do 
      expect(Vibrant::Vibrant.rgb2hsl(255,0,0)).to eq [0.0,1.0, 0.5]
    end
    it 'green' do 
      expect(Vibrant::Vibrant.rgb2hsl(0,255,0)).to eq [120.0/360.0,1.0,0.5]
    end
    it 'blue' do 
      expect(Vibrant::Vibrant.rgb2hsl(0,0,255)).to eq [240.0/360.0,1.0,0.5]
    end
  end
  
  describe 'hue2rgb'
  describe 'hsl2rgb'
end
