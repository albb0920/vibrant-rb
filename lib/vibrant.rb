# encoding: utf-8

require 'vibrant/version'
require 'rmagick'

require 'vibrant/swatch'
require 'vibrant/vibrant'

module Vibrant

  def self.read(sourceImage, color_count: 64, quality: 5)
    Vibrant.new(sourceImage, color_count: color_count, quality:quality).swatches
  end

end
