#require "vibrant/version"
require "rmagick"

module Vibrant

  class Swatch

    attr_accessor :population, :rgb

    def initialize(rgb, population)
      @population = population
      @rgb = rgb
      @hsl = nil
      @population = 1
      @yiq = 0
    end

    def hsl
      @hsl ||= Vibrant.rgb2hsl(@rgb[0], @rgb[1], @rgb[2])
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

    protected

    def ensure_text_colors
      @yiq ||= (@rgb[0] * 299 + @rgb[1] * 587 + @rgb[2] * 114) / 1000
    end

  end

  class Vibrant

    TARGET_DARK_LUMA = 0.26
    MAX_DARK_LUMA = 0.45
    MIN_LIGHT_LUMA = 0.55
    TARGET_LIGHT_LUMA = 0.74

    MIN_NORMAL_LUMA = 0.3
    TARGET_NORMAL_LUMA = 0.5
    MAX_NORMAL_LUMA = 0.7

    TARGET_MUTED_SATURATION = 0.3
    MAX_MUTED_SATURATION = 0.4

    TARGET_VIBRANT_SATURATION = 1
    MIN_VIBRANT_SATURATION = 0.35

    WEIGHT_SATURATION = 3
    WEIGHT_LUMA = 6
    WEIGHT_POPULATION = 1

    @@highestPopulation = 0

    def initialize(sourceImage, color_count: 64, quality: 5)
      @color_count = color_count
      @_swatches = []

      img = Magick::Image.read(sourceImage)[0].quantize(@color_count)
      
      pixels = [] 
      for y in 0..img.rows
        for x in 0..img.columns 
          pixels.push([x, y])
        end
      end

      i = 0
      cmap = {}
      @_swatches = []
      while i < pixels.length
        pos = pixels[i]
        pixel = img.pixel_color(pos[0], pos[1]) # 元画像のピクセルを取得
        r = pixel.red / 257
        g = pixel.green / 257
        b = pixel.blue / 257
        a = pixel.opacity / 257
        #p pixel.to_s

        # TODO jpegとpngでrgbとrgbaが、混ざってる

        #if a >= 125 && !(r > 250 and g > 250 and b > 250)
        if !(r > 250 and g > 250 and b > 250)
          rgb = [r, g, b]
          val = cmap[rgb.join] || [rgb, 0]

          # 本当はここでquantizeしたい

          val[1] += 1
          cmap[rgb.join] = val
        end
        i = i + quality
      end

      cmap.each_pair do |key, val|
        #p "#{val[0]}: #{val[1]}"
        @_swatches.push(Swatch.new(val[0], val[1]))
      end

      @maxPopulation = @_swatches.collect(&:population).max

      @vibrantSwatch = find_color_variation(TARGET_NORMAL_LUMA, MIN_NORMAL_LUMA, MAX_NORMAL_LUMA, TARGET_VIBRANT_SATURATION, MIN_VIBRANT_SATURATION, 1)
      @lightVibrantSwatch = find_color_variation(TARGET_LIGHT_LUMA, MIN_LIGHT_LUMA, 1, TARGET_VIBRANT_SATURATION, MIN_VIBRANT_SATURATION, 1)
      @darkVibrantSwatch = find_color_variation(TARGET_DARK_LUMA, 0, MAX_DARK_LUMA, TARGET_VIBRANT_SATURATION, MIN_VIBRANT_SATURATION, 1)
      @mutedSwatch = find_color_variation(TARGET_NORMAL_LUMA, MIN_NORMAL_LUMA, MAX_NORMAL_LUMA, TARGET_MUTED_SATURATION, 0, MAX_MUTED_SATURATION)
      @lightMutedSwatch = find_color_variation(TARGET_LIGHT_LUMA, MIN_LIGHT_LUMA, 1, TARGET_MUTED_SATURATION, 0, MAX_MUTED_SATURATION)
      @darkMutedSwatch = find_color_variation(TARGET_DARK_LUMA, 0, MAX_DARK_LUMA, TARGET_MUTED_SATURATION, 0, MAX_MUTED_SATURATION)

      if @vibrantSwatch.nil? && !@darkVibrantSwatch.nil?
        hsl = @DarkVibrantSwatch.getHsl()
        hsl[2] = TARGET_NORMAL_LUMA
        @vibrantSwatch = Swatch.new(Vibrant.hsl2rgb(hsl[0], hsl[1], hsl[2]), 0)
      end

      if @darkVibrantSwatch.nil? && !@vibrantSwatch.nil?
        hsl = @vibrantSwatch.getHsl()
        hsl[2] = TARGET_DARK_LUMA
        @darkVibrantSwatch = Swatch.new(Vibrant.hsl2rgb(hsl[0], hsl[1], hsl[2]), 0)
      end
    end

    def find_color_variation(targetLuma, minLuma, maxLuma, targetSaturation, minSaturation, maxSaturation)
      max = nil
      maxValue = 0
      @_swatches.each do |swatch|
        sat = swatch.hsl[1]
        luma = swatch.hsl[2]
        if sat.between?(minSaturation, maxSaturation) &&
            luma.between?(minLuma, maxLuma) && !already_selected?(swatch)
          value = create_comparison_value(sat, targetSaturation, luma, targetLuma, swatch.population, @maxPopulation)
          if max.nil? || value > maxValue
            max = swatch
            maxValue = value
          end
        end
      end
      max
    end

    def create_comparison_value(saturation, targetSaturation, luma, targetLuma, population, maxPopulation)
      self.weightedMean([
                            [invert_diff(saturation, targetSaturation), WEIGHT_SATURATION],
                            [invert_diff(luma, targetLuma), WEIGHT_LUMA],
                            [(population / maxPopulation), WEIGHT_POPULATION]
                        ])
    end

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

    def swatches
      {
          vibrant: @vibrantSwatch,
          muted: @mutedSwatch,
          dark_vibrant: @darkVibrantSwatch,
          dark_muted: @darkMutedSwatch,
          light_vibrant: @lightVibrantSwatch,
          light_muted: @lightMuted
      }
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

      def rgb2hsl(r, g, b)
        r = r.to_f / 255.0
        g = g.to_f / 255.0
        b = b.to_f / 255.0
        max = [r,g,b].max
        min = [r,g,b].min

        h = nil
        s = nil
        l = (max + min) / 2

        if max == min
          h = s = 0
          # achromatic
        else
          d = max - min
          s = if l > 0.5 
                d / (2 - max - min) 
              else
                d / (max + min)
              end

          h = case max
                when r
                  (g - b) / d + (g < b ? 6 : 0)
                when g
                  (b - r) / d + 2
                when b
                  (r - g) / d + 4
                else
                  nil
              end
          h /= 6
        end
        [h, s, l]
      end

      def hue2rgb(p, q, t)
        if t < 0
          t += 1
        end
        if t > 1
          t -= 1
        end
        if t < 1 / 6
          return p + (q - p) * 6 * t
        end
        if t < 1 / 2
          return q
        end
        if t < 2 / 3
          return p + (q - p) * (2 / 3 - t) * 6
        end
        p
      end

      def hsl2rgb(h, s, l)
        r = g = b = nil
        if s == 0
          r = g = b = l # achromatic
        else
          q= if l < 0.5
               l * (1 + s)
             else
               l + s - (l * s)
             end
          p = (2 * l) - q

          r = hue2rgb(p, q, h + (1 / 3))
          g = hue2rgb(p, q, h)
          b = hue2rgb(p, q, h - (1 / 3))
        end
        [r * 255, g * 255, b * 255]
      end

    end
  end
end
