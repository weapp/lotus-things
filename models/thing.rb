require 'lotus/model'
require_relative './by_user'

class Thing
  include Lotus::Entity
  # include ::AutoNotify
  self.attributes = :additional_type, :alternate_name, :description, :image, 
                    :name, :potential_action, :same_as, :url,
                    :created_at, :updated_at, :created_by, :updated_by, :slug

  def by_user(user, &block)
    ByUser.new(self, user, &block)
  end

  def trigger_create
    notify :on_created
  end
end