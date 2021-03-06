# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'upstit/version'

Gem::Specification.new do |spec|
  spec.name          = "upstit"
  spec.version       = Upstit::VERSION
  spec.authors       = ["Holger von Ameln"]
  spec.email         = ["holger@bit-vonameln.de"]
  spec.description   = %q{Retrieve time in transit for UPS Packages}
  spec.summary       = %q{uses the UPS time in transit webservice}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency('httparty')
  spec.add_dependency('savon', '~> 2')
end
