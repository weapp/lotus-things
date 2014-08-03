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
  name: "Manuel",
  alternate_name: "Manu",
  description: "ruby developer",
  image: "https://avatars2.githubusercontent.com/u/856974",
  url: "https://github.com/weapp",
  same_as: "https://twitter.com/weapp",
  created_at: Time.now,
  updated_at: Time.now,
  slug: "manu",
)
# thing.created_at = thing
# thing.updated_by = thing


puts "all:"
pp ThingRepository.all[0..4]
puts

puts "first:"
pp ThingRepository.first
puts

puts "create:"
pp ThingRepository.create thing
puts

puts "last:"
pp ThingRepository.last
puts

puts "find:"
pp l = ThingRepository.find(ThingRepository.last.id)
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