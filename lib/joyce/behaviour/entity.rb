module Joyce
  module Behaviour
    
    module Entity
      def self.included(base)
        base.has_many :activities_as_actor, :class_name => Joyce::Activity, :as => :actor, :dependent => :destroy
        base.has_many :activities_as_obj, :class_name => Joyce::Activity, :as => :obj, :dependent => :destroy
      end
    end
    
  end
end
