require 'rubygems'
require 'bundler/setup'

require 'lotus/utils/class'

require 'pp'

# require './lib/auto_wrap'
# require './lib/auto_notify'

# require './app/wrappers/ability_wrapper'
# require './app/wrappers/timestamp_wrapper'
	
require './models/thing'
require './models/thing_repository'
require './models/user'
require './models/movie'
require './models/person'


# include AutoWrap::WrapsHelper


def current_user
  @current_user ||= User.new
end

def current_ability
  @current_ability ||= Ability.new(current_user)
end


thing = Thing.new(
  name: "Things",
  alternate_name: "thingsapp",
  description: "ruby app",
  image: nil,
  url: "https://thingsapp.com/",
  same_as: "https://twitter.com/things",
  slug: "things",
)

user = Person.new(
  name: "Manuel",
  alternate_name: "Manu",
  description: "ruby developer",
  image: "https://avatars2.githubusercontent.com/u/856974",
  url: "https://github.com/weapp",
  same_as: "https://twitter.com/weapp",
  slug: "manu",
)

puts "delete:"
loop do
  last = ThingRepository.last
  break if last.id < 400
  pp ThingRepository.delete(last)
end
puts

puts "all:"
pp ThingRepository.all[0..4]
puts

puts "first:"
pp ThingRepository.first
puts

puts "create:"
pp ThingRepository.create user
pp ThingRepository.create_with_creator thing, user
puts

puts "last:"
pp ThingRepository.last
puts

puts "find:"
pp l = ThingRepository.find(ThingRepository.last.id)
puts

puts "find_by_name:"
pp ThingRepository.find_by_name("Manuel")
puts

puts "delete:"
last = ThingRepository.last
pp ThingRepository.delete(last)
puts


last = ThingRepository.last
pp last

# pp ThingRepository.persist(thing)

exit


thing = Thing.new
person = Person.new

th = thing.by_user(User.new("admin"))

puts
puts "try to modify by admin user"
puts th.authorize!(:write).name="success!"

th = thing.by_user(User.new(false))

puts
puts "try to modify by normal user"
puts th.authorize!(:write){OpenStruct.new}.name="success! even error!"

puts
puts "real value:"
puts th.name