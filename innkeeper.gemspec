# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'innkeeper/version'

Gem::Specification.new do |spec|
  spec.name          = "innkeeper"
  spec.version       = Innkeeper::VERSION
  spec.authors       = ["Mike Goggin"]
  spec.email         = ["mgoggin@dvauction.com"]
  spec.summary       = %q{Easy multitenancy in Rack.}
  spec.description   = %q{Quickly and easily configure multitenant applications divided by either subdomain or host domain.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_dependency "ipaddress"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
