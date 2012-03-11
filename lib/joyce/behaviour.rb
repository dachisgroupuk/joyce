module Joyce
  module Behaviour
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def act_as_joyce
        has_many :streams
      end
    end
  end
end
