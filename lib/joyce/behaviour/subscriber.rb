module Joyce
  class NoSubscriptionError < RuntimeError; end
  class DuplicateSubscriptionError < RuntimeError; end
  
  module Behaviour
    
    module Subscriber
      
      def self.included(base)
        base.has_many :stream_subscriptions, :class_name => 'Joyce::StreamSubscriber', :as => :subscriber
      end
      
      def subscribe_to(producer)
        stream = stream_from_producer(producer)
        raise DuplicateSubscriptionError.new("An open subscription to #{producer} already exists") unless stream_subscriptions.where(:stream_id => stream.id, :ended_at => nil).empty?
        
        Joyce::StreamSubscriber.create(:subscriber => self, :stream => stream, :started_at => Time.now)
      end
      
      def unsubscribe_from(producer)
        stream = stream_from_producer(producer)
        stream_subscriber = stream_subscriptions.where(:stream_id => stream.id).first
        raise NoSubscriptionError.new("No subscription to #{producer} could be found") if stream_subscriber.nil?

        stream_subscriber.ended_at = Time.now
        stream_subscriber.save
      end
      
      def subscribed_activity_stream
        Joyce::Activity
          .joins("JOIN joyce_activities_streams AS jas ON joyce_activities.id = jas.activity_id")
          .joins("JOIN joyce_streams_subscribers AS jss ON jss.stream_id = jas.stream_id")
          .where("jss" => {:subscriber_id => self.id, :subscriber_type => self.class})
          .where("joyce_activities.created_at <= jss.ended_at OR jss.ended_at IS NULL")
          .where("joyce_activities.created_at >= jss.started_at")
          .order("joyce_activities.created_at DESC")
      end
      
      def subscribed_to?(producer)
        stream = stream_from_producer(producer)
        !stream_subscriptions.where(:stream_id => stream.id, :ended_at => nil).empty?
      end


      private

      def stream_from_producer(producer)
        if producer.is_a?(Joyce::Stream)
          stream = producer
        elsif producer.is_a?(Joyce::Behaviour::Owner)
          stream = Joyce::Stream.find_or_create_by_owner(producer)
        else
          raise ArgumentError.new("Either a Stream or a stream Owner should be specified")
        end
      end
    end
    
  end
  
end
