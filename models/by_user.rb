require_relative "./ability"
require "active_support/core_ext/module/delegation"

class ByUser
  attr_accessor :model
  attr_reader :user, :ability

  def initialize(model, user, ability_class=Ability, &block)
    @ability_class = ability_class
    self.model = model
    self.user = user
    if block_given?
      puts "yiiiha"
      @block = block
    else
      @block = Proc.new do |model, method_name, *args|
        if args.last.kind_of?(Hash) && args.last.has_key?(:unauthorized_message)
          message = args.pop[:unauthorized_message]
        else
          message = "Access denied! You can't `#{method_name}' for #{model}"
        end
        raise CanCan::AccessDenied.new(message, method_name, model)
      end
    end
  end

  def user=(user)
    @user = user
    @ability = @ability_class.new(user)
  end

  def can?(action, *args)
    ability.can?(action, self, *args)
  end

  def cannot?(action, *extra_args)
    ability.cannot?(action, self, *extra_args)
  end

  def authorize!(action, *args, &block)
    if block_given?
      if can? action, *args
        model
      else
        block.call
      end
    else
      ability.authorize!(action, self, *args)
      model
    end
  end

  def method_missing(method_name, *args, &block)
    raise NoMethodError.new("undefined method `#{method_name}' for #{model}") unless model.respond_to? method_name
    if can?(method_name)
      model.public_send(method_name, *args, &block)
    else
      unauthorized! method_name, *args
    end
    #
    # Alternative way, maybe quicker, test it
    #
    # eigenclass = class << self; self; end
    # eigenclass.class_eval do
    #   define_method method_name do |*args, &block|
    #     if @ability.can?(method_name, model)
    #       model.public_send(method_name, *args, &block)
    #     else
    #       @block.call(method_name, model)
    #     end
    #   end
    # end    
    # send(method_name, *args, &block)
    #
  end

  def unauthorized!(method_name, *args)
    if args.last.kind_of?(Hash) && args.last.has_key?(:unauthorized)
      unauthorized = args.pop[:unauthorized]
    else
      unauthorized = @block
    end
    unauthorized.call(model, method_name, *args)
  end

  def respond_to_missing?(method_name, include_private = false)
    model.respond_to?(method_name, include_private) || super
  end

  def class
    model.class
  end

end