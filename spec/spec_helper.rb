require "active_attr/rspec"

require 'lotus/model/adapters/neo4j_adapter'
require 'lotus/model/mapping/active_coercer'

require 'foodies/repositories/thing_repository'
require 'foodies/thing'
require 'foodies/person'
require 'foodies/recipe'


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def build_thing(name="Things", alternate_name="thingsapp")
  Thing.new(
    name: name,
    alternate_name: alternate_name,
    description: "ruby app",
    image: nil,
    url: "https://#{"thingsapp"}.com/",
    same_as: "https://twitter.com/#{alternate_name}",
    slug: "#{alternate_name}",
  )
end

def build_person(name="Manuel", alternate_name="weapp")
  Person.new(
    name: name,
    alternate_name: alternate_name,
    description: "ruby developer",
    image: "https://avatars2.githubusercontent.com/u/#{alternate_name}",
    url: "https://github.com/#{alternate_name}",
    same_as: "https://twitter.com/#{alternate_name}",
    slug: "#{alternate_name}",
  )
end
