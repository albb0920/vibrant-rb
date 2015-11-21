# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vibrant/version'

Gem::Specification.new do |spec|
  spec.name          = "vibrant-rb"
  spec.version       = Vibrant::VERSION
  spec.authors       = ["dondoco7"]
  spec.email         = ["dondoco7@gmail.com"]

  spec.summary       = %q{Get color variations from an image.}
  spec.description   = %q{Get color variations from an image. Original is 'http://jariz.github.io/vibrant.js'}
  spec.homepage      = "https://github.com/dondoco7/vibrant-rb/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rmagick", ">= 2.14"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
