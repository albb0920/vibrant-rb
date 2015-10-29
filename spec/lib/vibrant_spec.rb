require "spec_helper"
require 'vibrant'

describe Vibrant::Vibrant do
  it "is 色抽出" do 
    vibrant = Vibrant::Vibrant.new('examples/1.jpg')
    swatches = vibrant.swatches
    expect(swatches[:vibrant]).to eq ''
    expect(swatches[:muted]).to eq ''
    expect(swatches[:dark_vibrant]).to eq ''
    expect(swatches[:dark_muted]).to eq ''
    expect(swatches[:light_vibrant]).to eq ''
    expect(swatches[:light_muted]).to eq ''
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
