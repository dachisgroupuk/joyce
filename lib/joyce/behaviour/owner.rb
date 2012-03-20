module Joyce
  module Behaviour
    
    module Owner
      def self.included(base)
        base.extend ClassWithStream
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
