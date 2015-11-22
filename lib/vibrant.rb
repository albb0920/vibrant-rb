# encoding: utf-8

require 'vibrant/version'
require 'rmagick'
require 'tempfile'

require 'vibrant/swatch'
require 'vibrant/vibrant'

module Vibrant

  def self.read(file_or_path, color_count: 64, quality: 5, use_tempfile: false)
    if use_tempfile
      if file_or_path.is_a?(String)
        open(file_or_path, 'r') do |file|
          _read_with_temp(file, color_count: color_count, quality: quality)
        end
      else
        _read_with_temp(file_or_path, color_count: color_count, quality: quality)
      end
    else
      _read(file_or_path, color_count: color_count, quality: quality)
    end
  end

  def self._read_with_temp(file, color_count: 64, quality: 5)
    Tempfile.open(['vibrant']) do |tempfile|
      tempfile.write(file.read)
      read(tempfile.path)
    end
  end

  def self._read(file_or_path, color_count: 64, quality: 5)
    Vibrant.new(file_or_path, color_count: color_count, quality: quality).swatches
  end

end
