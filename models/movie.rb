require_relative './thing'

class Movie < Thing
  self.attributes = [:_node_, :title, :released, :tagline]
end