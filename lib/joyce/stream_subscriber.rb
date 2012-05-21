require 'active_record'

module Joyce
  class StreamSubscriber < ActiveRecord::Base
    self.table_name = 'joyce_streams_subscribers'
    
    belongs_to :subscriber, :polymorphic => true
    belongs_to :stream
    
    validates_presence_of :subscriber, :stream, :started_at

    module Scopes
      
      def active_at(inspection_date=Time.now)
        where('started_at <= ?', inspection_date)
        .where('ended_at IS NULL OR ended_at >= ?', inspection_date)
      end
      
      def subscribed_by(subscriber)
        where(:subscriber_id => subscriber.id)
        .where(:subscriber_type => subscriber.class.to_s)
      end
      
    end
    extend Scopes
  end
end
