module Joyce
  module Behaviour
    
    module Subscriber
      def self.included(base)
        base.has_many :stream_subscriptions, :class_name => 'Joyce::StreamSubscriber', :as => :subscriber
      end
      
      def subscribe_to(producer)
        if producer.is_a?(Joyce::Stream)
          Joyce::StreamSubscriber.create(:subscriber => self, :stream => producer, :started_at => Time.now)
        elsif producer.is_a?(Joyce::Behaviour::Owner)
          Joyce::StreamSubscriber.create(:subscriber => self, :stream => Joyce::Stream.find_or_create_by_owner(producer), :started_at => Time.now)
        end
      end
    end
    
    def unsubscribe_from(producer)
      
    end
    
  end
end
