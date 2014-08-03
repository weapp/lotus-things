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

# puts "delete:"
# loop do
#   last = ThingRepository.last
#   break if last.id < 400
#   pp ThingRepository.delete(last)
# end
# puts

# puts "director_movie:"
# pp ThingRepository.director_movie
# puts



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