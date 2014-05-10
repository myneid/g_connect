# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g_connect/version'

Gem::Specification.new do |spec|
  spec.name          = "g_connect"
  spec.version       = GConnect::VERSION
  spec.authors       = ["Nicolas Aguttes"]
  spec.email         = ["nicolas.aguttes@gmail..com"]
  spec.summary       = %q{Garmin connect connection}
  spec.description   = %q{Gem to connect to Garmin Connect site and read activities recorded}
  spec.homepage      = "https://github.com/tranquiliste/g_connect"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_dependency "mechanize", "2.7.3"
  spec.add_dependency "json"
end
