require 'lotus/model'
require_relative './by_user'

class Thing
  include Lotus::Entity
  # include ::AutoNotify
  self.attributes = :additional_type, :alternate_name, :description, :image, 
                    :name, :potential_action, :same_as, :url,
                    :created_at, :updated_at, :slug

  # linked with: Person, as: :created_by
  # linked with: Person, as: :updated_by

  def by_user(user, &block)
    ByUser.new(self, user, &block)
  end

  def trigger_create
    notify :on_created
  end

  def serializable_hash
    attrs = self.class.attributes
    attrs.inject({}){|hsh, attr| hsh[attr] = send(attr) ; hsh }
  end

end