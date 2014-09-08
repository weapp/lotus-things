# coding: utf-8
lib = File.expand_path('../lib/neo4j_adapter', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neo4j_adapter/version'

Gem::Specification.new do |spec|
  spec.name          = 'neo4j_adapter'
  spec.version       = Neo4jAdapter::VERSION
  spec.authors       = ["Manuel Albarrán"]
  spec.email         = ["weap88@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib/neo4j_adapter']

  spec.add_dependency 'lotus-model',       '~> 0.1'
  spec.add_dependency 'cypherites'
  spec.add_dependency 'headjack'
  spec.add_dependency 'macaddr'
  spec.add_dependency 'deep_dive'
end
