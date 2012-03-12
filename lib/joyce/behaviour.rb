module Joyce
  module Behaviour
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def act_as_joyce
        has_many :streams, :class_name => Joyce::Stream, :as => :owner
        
        include Joyce::Behaviour::Owner
      end
    end
  end
end
