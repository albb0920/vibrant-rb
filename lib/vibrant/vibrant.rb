# encoding: utf-8
module Vibrant

  class Vibrant

    TARGET_DARK_LUNA = 0.26
    MAX_DARK_LUNA = 0.45
    MIN_LIGHT_LUNA = 0.55
    TARGET_LIGHT_LUNA = 0.74

    MIN_NORMAL_LUNA = 0.3
    TARGET_NORMAL_LUNA = 0.5
    MAX_NORMAL_LUNA = 0.7

    TARGET_MUTED_SATURATION = 0.3
    MAX_MUTED_SATURATION = 0.4

    TARGET_VIBRANT_SATURATION = 1
    MIN_VIBRANT_SATURATION = 0.35

    NORMAL_LUNA = {
        target: TARGET_NORMAL_LUNA,
        range: MIN_NORMAL_LUNA..MAX_NORMAL_LUNA
    }
    LIGHT_LUNA = {
        target: TARGET_LIGHT_LUNA,
        range: MIN_LIGHT_LUNA..1
    }
    DARK_LUNA = {
        target: TARGET_DARK_LUNA,
        range: 0..MAX_DARK_LUNA
    }

    VIBRANT_SATURATION = {
        target: TARGET_VIBRANT_SATURATION,
        range: MIN_VIBRANT_SATURATION..1
    }
    MUTED_SATURATION = {
        target: TARGET_MUTED_SATURATION,
        range: 0..MAX_MUTED_SATURATION
    }

    WEIGHT_SATURATION = 3
    WEIGHT_LUNA = 6
    WEIGHT_POPULATION = 1

    @@highestPopulation = 0

    # def initialize(sourceImage, color_count: 64, quality: 5)
    #   @img = Magick::Image.from_blob(sourceImage.read).file.quantize(@color_count)
    #   @process
    # end

    def initialize(sourceImage, color_count: 64, quality: 5)
      @color_count = color_count
      @quality = quality
      @image = Magick::Image.read(sourceImage).first.quantize(@color_count)
      process
    end

    def process

      @_swatches = []

      # histogram
      histogram = @image.color_histogram.inject({}) { |h, pair|
        hex = pair[0].to_color(Magick::AllCompliance, false, 8, true)
        hsla = pair[0].to_hsla
        count = pair[1]

        h[hex] ||= {
            hex: hex,
            hsla: hsla,
            count: 0
        }
        h[hex][:count] += count
        h
      }.each_pair { |key, val|
        @_swatches.push(Swatch.new(val[:hex], val[:hsla], val[:count]))
      }

      @maxPopulation = @_swatches.collect(&:population).max

      @vibrantSwatch = find_color_variation(NORMAL_LUNA, VIBRANT_SATURATION)
      @lightVibrantSwatch = find_color_variation(LIGHT_LUNA, VIBRANT_SATURATION)
      @darkVibrantSwatch = find_color_variation(DARK_LUNA, VIBRANT_SATURATION)
      @mutedSwatch = find_color_variation(NORMAL_LUNA, MUTED_SATURATION)
      @lightMutedSwatch = find_color_variation(LIGHT_LUNA, MUTED_SATURATION)
      @darkMutedSwatch = find_color_variation(DARK_LUNA, MUTED_SATURATION)

      if @vibrantSwatch.nil? && !@darkVibrantSwatch.nil?
        hsla = @DarkVibrantSwatch.hsla.dup
        hsla[2] = TARGET_NORMAL_LUNA
        @vibrantSwatch = Swatch.new(@DarkVibrantSwatch.hex, hsla, 0)
      end

      if @darkVibrantSwatch.nil? && !@vibrantSwatch.nil?
        hsla = @vibrantSwatch.hsla.dup
        hsla[2] = TARGET_DARK_LUNA
        @darkVibrantSwatch = Swatch.new(@vibrantSwatch.hex, hsla, 0)
      end

    end

    def find_color_variation(luna, saturation)
      max = nil
      maxValue = 0

      @_swatches.each do |swatch|
        #h = swatch.hsla[0] / 360
        s = swatch.hsla[1] / 255
        l = swatch.hsla[2] / 255

        if luna[:range].include?(l) && saturation[:range].include?(s) && !already_selected?(swatch)

          value = create_comparison_value(s, saturation[:target], l, luna[:target], swatch.population, @maxPopulation)
          if max.nil? || value > maxValue
            max = swatch
            maxValue = value
          end
        end
      end

      max
    end

    def create_comparison_value(saturation, targetSaturation, luna, target_luna, population, max_population)
      self.class.weightedMean([
                                  [self.class.invert_diff(saturation, targetSaturation), WEIGHT_SATURATION],
                                  [self.class.invert_diff(luna, target_luna), WEIGHT_LUNA],
                                  [(population / max_population), WEIGHT_POPULATION]
                              ])
    end


    def swatches
      Swatches.new(
          vibrant: @vibrantSwatch,
          muted: @mutedSwatch,
          dark_vibrant: @darkVibrantSwatch,
          dark_muted: @darkMutedSwatch,
          light_vibrant: @lightVibrantSwatch,
          light_muted: @lightMutedSwatch
      )
    end

    def already_selected?(swatch)
      return @vibrantSwatch == swatch ||
          @darkVibrantSwatch == swatch ||
          @lightVibrantSwatch == swatch ||
          @mutedSwatch == swatch ||
          @darkMutedSwatch == swatch ||
          @lightMutedSwatch == swatch
    end

    class << self

      def invert_diff(value, targetValue)
        1 - (value - targetValue).abs
      end

      def weightedMean(values)
        sum = 0
        sumWeight = 0
        values.each do |v|
          value = v[0]
          weight = v[1]
          sum += value * weight
          sumWeight += weight
        end
        sum / sumWeight
      end
    end

  end
end
