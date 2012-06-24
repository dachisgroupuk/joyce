module Joyce
  module Behaviour
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # Turns a class into a joyce-enabled model.
      # This will bestow upon the class the properties of a {Behaviour::Owner} and a {Behaviour::Subscriber}.
      # 
      # @example
      #   class User < ActiveRecord::Base
      #     acts_as_joyce
      #   end
      def acts_as_joyce
        include Joyce::Behaviour::Owner
        include Joyce::Behaviour::Subscriber
        include Joyce::Behaviour::Entity
      end
    end
  end
end
