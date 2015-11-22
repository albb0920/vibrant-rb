# encoding: utf-8

require 'vibrant/version'
require 'rmagick'

require 'vibrant/swatch'
require 'vibrant/vibrant'

module Vibrant

  def self.read(sourceImage, color_count: 64, quality: 5)
    Vibrant.new(sourceImage, color_count: color_count, quality:quality).swatches
  end

  def self.rgb2hsl(r, g, b)
    r = r.to_f / 255.0
    g = g.to_f / 255.0
    b = b.to_f / 255.0
    max = [r, g, b].max
    min = [r, g, b].min

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

  def self.hue2rgb(p, q, t)
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

  def self.hsl2rgb(h, s, l)
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
