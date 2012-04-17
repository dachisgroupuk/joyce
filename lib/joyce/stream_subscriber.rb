require 'active_record'

module Joyce
  class StreamSubscriber < ActiveRecord::Base
    self.table_name = 'joyce_streams_subscribers'
    
    belongs_to :subscriber, :polymorphic => true
    belongs_to :stream
    
    validates_presence_of :subscriber, :stream, :started_at

    def active_at(inspection_date=Time.now)
      started_at <= inspection_date && (ended_at == nil || ended_at >= inspection_date)
    end
  end
end
