require "active_attr/rspec"

require './models/thing_repository'
require './models/thing'
require './models/person'
require './models/recipe'

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
