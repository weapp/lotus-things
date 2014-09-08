require 'active_attr'
# require 'lotus/model'
require_relative './by_user'

class Thing
  include ActiveAttr::Model
  # include Lotus::Entity
  # include ::AutoNotify
  attribute :id
  attribute :type
  attribute :additional_type
  attribute :alternate_name
  attribute :description
  attribute :image
  attribute :name
  attribute :potential_action
  attribute :same_as
  attribute :url
  attribute :slug
  # :created_at, :updated_at,
  # linked with: Person, as: :created_by
  # linked with: Person, as: :updated_by

  def by_user(user, &block)
    ByUser.new(self, user, &block)
  end

  def trigger_create
    notify :on_created
  end

  # def serializable_hash
  #   attrs = self.class.attributes
  #   attrs.inject({}){|hsh, attr| hsh[attr] = send(attr) ; hsh }
  # end

  def == other
    self.id == other.id if self.id && other.kind_of?(Thing)
  end

  def inspect
    "#<#{self.class} id: #{id.inspect}, name: #{name.inspect}>"
  end

end