require_relative './user'

require 'active_support/core_ext'
I18n.enforce_available_locales = false

require 'cancancan'

class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= User.new # guest user (not logged in)

      alias_action :create, :read, :update, :destroy, :to => :crud

      if user.admin?
        can :manage, :all
      else
        # can :read, :all
        # can :manage, Article  # user can perform any action on the article
        # can :crud, [Article, User]
        # can [:read, :activate!], Article, :active => true, :user_id => user.id
        can [:name=] + Thing.attributes , Thing
      end
    end
end
