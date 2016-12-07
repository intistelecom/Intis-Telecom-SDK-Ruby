# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'intis/sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "intis-sdk"
  spec.version       = Intis::Sdk::VERSION
  spec.authors       = ["Konstantin Shlyk"]
  spec.email         = ["konstantin@shlyk.org"]
  spec.summary       = %q{Intis Telecom API Ruby SDK}
  spec.description   = %q{Ruby SDK for operating with Intis telecom API and sending SMS}
  spec.homepage      = "https://www.intistele.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
