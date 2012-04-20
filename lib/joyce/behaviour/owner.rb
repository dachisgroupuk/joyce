module Joyce
  module Behaviour
    
    module Owner
      def self.included(base)
        base.extend ClassWithStream
        base.has_many :streams, :class_name => Joyce::Stream, :as => :owner, :dependent => :destroy
        #base.has_and_belongs_to_many :activities, :join_table => "joyce_activities_targets"
      end
      
      def activity_stream
        Joyce::Activity
          .joins("JOIN joyce_activities_streams AS jas ON joyce_activities.id = jas.activity_id")
          .joins("JOIN joyce_streams ON joyce_streams.id = jas.stream_id")
          .where("joyce_streams" => {:name => nil, :owner_id => self.id, :owner_type => self.class})
      end
    end
    
  end
end
