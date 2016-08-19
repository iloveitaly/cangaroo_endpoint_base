# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cangaroo_endpoint_base/version'

Gem::Specification.new do |spec|
  spec.name          = "cangaroo_endpoint_base"
  spec.version       = CangarooEndpointBase::VERSION
  spec.authors       = ["Michael Bianco"]
  spec.email         = ["mike@cliffsidemedia.com"]

  spec.summary       = 'Helpers for developing a Cangaroo (Wombat replacement) endpoint'
  spec.homepage      = 'https://github.com/iloveitaly/cangaroo_endpoint_base'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'simple_structured_logger'
  spec.add_dependency 'rails'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
