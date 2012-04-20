module Joyce
  module Behaviour
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def acts_as_joyce
        include Joyce::Behaviour::Owner
        include Joyce::Behaviour::Subscriber
        include Joyce::Behaviour::Entity
      end
    end
  end
end
