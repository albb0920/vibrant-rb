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

    attr_accessor :population, :hex, :hsla

    def initialize(hex, hsla, population)
      @population = population
      @hex = hex
      @hsla = hsla
      @yiq = 0
    end

    # def title_text_color
    #   @ensure_text_colors
    #   @yiq<200 ? "#fff" : "#000"
    # end
    #
    # def body_text_color
    #   @ensure_text_colors
    #   @yiq<150 ? "#fff" : "#000"
    # end
    #
    #protected
    #
    # def ensure_text_colors
    #   @yiq ||= (@rgb[0] * 299 + @rgb[1] * 587 + @rgb[2] * 114) / 1000
    # end

  end

end