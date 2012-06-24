module Joyce
  class NoSubscriptionError < RuntimeError; end
  class DuplicateSubscriptionError < RuntimeError; end
  
  module Behaviour
    
    module Subscriber
      
      def self.included(base)
        base.has_many :stream_subscriptions, :class_name => 'Joyce::StreamSubscriber', :as => :subscriber, :include => :stream, :dependent => :destroy
      end
      
      # Subscribes to a stream or a stream owner.
      # If the parameter is a stream owner, the method will subscribe to the associated stream.
      # 
      # @param producer [Stream, Behaviour::Owner] the activity producer to subscribe to.
      def subscribe_to(producer)
        stream = stream_from_producer(producer)
        raise DuplicateSubscriptionError.new("An open subscription to #{producer} already exists") unless stream_subscriptions.where(:stream_id => stream.id, :ended_at => nil).empty?
        
        Joyce::StreamSubscriber.create(:subscriber => self, :stream => stream, :started_at => Time.now)
      end
      
      # Unsubscribes from a stream or a stream owner.
      # If the parameter is a stream owner, the method will unsubscribe from the associated stream.
      # 
      # @param producer [Stream, Behaviour::Owner] the activity producer to unsubscribe from.
      def unsubscribe_from(producer)
        stream = stream_from_producer(producer)
        stream_subscriber = stream_subscriptions.where(:stream_id => stream.id, :ended_at => nil).first
        raise NoSubscriptionError.new("No subscription to #{producer} could be found") if stream_subscriber.nil?

        stream_subscriber.ended_at = Time.now
        stream_subscriber.save
      end
      
      # Returns all activities for the subscribed streams.
      def subscribed_activity_stream
        Joyce::Activity
          .joins("JOIN joyce_activities_streams AS jas ON joyce_activities.id = jas.activity_id")
          .joins("JOIN joyce_streams_subscribers AS jss ON jss.stream_id = jas.stream_id")
          .where("jss" => {:subscriber_id => self.id, :subscriber_type => self.class})
          .where("joyce_activities.created_at <= jss.ended_at OR jss.ended_at IS NULL")
          .where("joyce_activities.created_at >= jss.started_at")
          .order("joyce_activities.created_at DESC")
          .uniq
      end
      
      # Returns whether the instance is subscribed to a stream or a stream owner.
      # 
      # @param producer [Stream, Behaviour::Owner] the activity producer to check subscription against.
      # @return [Boolean]
      def subscribed_to?(producer)
        stream = stream_from_producer(producer)
        !stream_subscriptions.where(:stream_id => stream.id, :ended_at => nil).empty?
      end
      
      # Returns all active subscriptions.
      # If the parameter is passed, return the subscriptions that were active at that time.
      # 
      # @param date_at [Time]
      def subscriptions(date_at = Time.now)
        self.stream_subscriptions.active_at(date_at).map{|ss| ss.stream.owner }.compact
      end
      
      # Returns only subscriptions that are instances of the class passed as a parameter.
      # 
      # @example
      #   john = User.create(:name => 'john')
      #   jane = User.create(:name => 'jane')
      #   blog = Blog.create
      #   john.subscribe_to(jane)
      #   john.subscribe_to(blog)
      # 
      #   john.typed_subscriptions(User) # => [jane]
      def typed_subscriptions(klass)
        klass
        .joins(:streams)
        .joins('JOIN joyce_streams_subscribers AS jss ON jss.stream_id = joyce_streams.id')
        .where('jss' => {:subscriber_id => self.id, :subscriber_type => self.class})
        .where('jss.ended_at IS NULL')
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
