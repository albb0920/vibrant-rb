# encoding: utf-8
module Vibrant

  class Swatches

    attr_reader :vibrant, :muted, :dark_vibrant, :dark_muted, :light_vibrant,:light_muted

    def initialize(vibrant: nil,
                   muted: nil,
                   dark_vibrant: nil,
                   dark_muted: nil,
                   light_vibrant: nil,
                   light_muted: nil)

      @vibrant = vibrant
      @muted = muted
      @dark_vibrant = dark_vibrant
      @dark_muted = dark_muted
      @light_vibrant = light_vibrant
      @light_muted = light_muted

    end

  end

  class Swatch

    attr_accessor :population, :rgb

    def initialize(rgb, population)
      @population = population
      @rgb = rgb
      @hsl = nil
      @yiq = 0
    end

    def hsl
      @hsl ||= ::Vibrant.rgb2hsl(@rgb[0], @rgb[1], @rgb[2])
    end

    def hex
      "#" + ((1 << 24) + (@rgb[0] << 16) + (@rgb[1] << 8) + @rgb[2]).to_s(16).slice(1, 7)
    end

    def title_text_color
      @ensure_text_colors
      @yiq<200 ? "#fff" : "#000"
    end

    def body_text_color
      @ensure_text_colors
      @yiq<150 ? "#fff" : "#000"
    end

    def to_s
      hex
    end

    protected

    def ensure_text_colors
      @yiq ||= (@rgb[0] * 299 + @rgb[1] * 587 + @rgb[2] * 114) / 1000
    end

  end

end