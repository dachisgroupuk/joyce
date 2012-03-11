require 'active_record'

module Joyce
  class Activity < ActiveRecord::Base
    self.table_name = 'joyce_activities'
    
    belongs_to :actor, :polymorphic => true
    belongs_to :obj, :polymorphic => true
    
    validates_presence_of :actor, :verb
  end
end
