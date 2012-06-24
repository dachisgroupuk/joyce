module Joyce
  module Behaviour
    
    module Owner
      def self.included(base)
        base.extend ClassWithStream
        base.extend Scopes
        base.has_many :streams, :class_name => Joyce::Stream, :as => :owner, :dependent => :destroy
        #base.has_and_belongs_to_many :activities, :join_table => "joyce_activities_targets"
      end
      
      # Returns all the activities for the instance.
      def activity_stream
        Joyce::Activity
          .joins("JOIN joyce_activities_streams AS jas ON joyce_activities.id = jas.activity_id")
          .joins("JOIN joyce_streams ON joyce_streams.id = jas.stream_id")
          .where("joyce_streams" => {:name => nil, :owner_id => self.id, :owner_type => self.class})
      end
      
      module Scopes
        # Returns all the instances that `subscriber` has ever subscribed to.
        # 
        # This means returning past subscriptions the subscriber is not subscribed to anymore.
        # 
        # @param subscriber [Behaviour::Subscriber]
        # @return [Array]
        def subscribed_by(subscriber)
          joins(:streams)
          .joins('JOIN joyce_streams_subscribers AS jss ON jss.stream_id = joyce_streams.id')
          .where("jss.subscriber_id = #{subscriber.id} AND jss.subscriber_type = '#{subscriber.class.to_s}'")
        end
        
        # Returns all the instances that `subscriber` is currently subscribed to.
        # 
        # @param subscriber [Behaviour::Subscriber]
        # @return [Array]
        def currently_subscribed_by(subscriber)
          subscribed_by(subscriber).where('jss.ended_at IS NULL')
        end
      end
    end
    
  end
end
