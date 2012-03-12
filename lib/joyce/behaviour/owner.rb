module Joyce
  module Behaviour
    
    module Owner
      def self.included receiver
        receiver.extend ClassMethods
      end
      
      def activity_stream
        stream = streams.where(:name => nil).first
        return [] if stream.nil?
        stream.activities
      end
      
      module ClassMethods
        def activity_stream
          Joyce::Activity
            .joins("JOIN joyce_activities_streams ON joyce_activities.id = joyce_activities_streams.activity_id")
            .joins("JOIN joyce_streams ON joyce_streams.id = joyce_activities_streams.stream_id")
            .where("joyce_streams" => {:name => nil, :owner_type => self})
        end
      end
    end
    
  end
end
