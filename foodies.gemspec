# coding: utf-8
lib = File.expand_path('../lib/foodies', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foodies/version'

Gem::Specification.new do |spec|
  spec.name          = 'foodies'
  spec.version       = Foodies::VERSION
  spec.authors       = ["Manuel Albarrán"]
  spec.email         = ["weap88@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib/foodies']

  # spec.add_dependency 'dotenv-deployment', '~> 0'
  # spec.add_dependency 'feedjira',          '~> 1'
  # spec.add_dependency 'sqlite3',           '~> 1.3'
  spec.add_dependency 'lotus-model',       '~> 0.1'
  # spec.add_dependency 'lotusrb',           '~> 0.1'

  # spec.add_development_dependency 'bundler',  '~> 1.6'
  # spec.add_development_dependency 'rake',     '~> 10.0'
  # spec.add_development_dependency 'dotenv',   '~> 0'
  # spec.add_development_dependency 'rspec',    '~> 3'
  # spec.add_development_dependency 'vcr',      '~> 2.7'
  # spec.add_development_dependency 'webmock',  '~> 1'
  # spec.add_development_dependency 'capybara', '~> 2'
end
