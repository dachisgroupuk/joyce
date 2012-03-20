module Joyce
  module Behaviour
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def acts_as_joyce
        include Joyce::Behaviour::Owner
        include Joyce::Behaviour::Subscriber
      end
    end
  end
end
