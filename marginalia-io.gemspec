# -*- encoding: utf-8 -*-
require File.expand_path('../lib/marginalia-io/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Pete Keen"]
  gem.email         = ["pete@marginalia.io"]
  gem.description   = "API and Command Line Client for Marginalia.io"
  gem.summary       = "Marginalia.io is a web-based note taking and journalling app using Markdown. This is the Ruby API for it."
  gem.homepage      = "https://www.marginalia.io"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "marginalia-io"
  gem.require_paths = ["lib"]
  gem.version       = Marginalia::IO::VERSION

  gem.add_dependency "netrc",    "~> 0.7.7"
  gem.add_dependency "httparty", "~> 0.8.3"
  gem.add_dependency "thor",     "~> 0.16.0"
end
