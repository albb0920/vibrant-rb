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
      expect(Vibrant::Vibrant.rgb2hsl(255,255,255)).to eq [0,0,100]
    end
    it 'red' do 
      expect(Vibrant::Vibrant.rgb2hsl(255,0,0)).to eq [0,0,100]
    end
  end
  
  describe 'hue2rgb'
  describe 'hsl2rgb'
end
