require 'active_record'

module Joyce
  class ActivityTarget < ActiveRecord::Base
    self.table_name = 'joyce_activities_targets'
    
    belongs_to :target, :polymorphic => true
    belongs_to :activity
    
    validates_presence_of :name, :target, :activity
    
    after_initialize :init
    
    
    private
    
    def init
      self.name ||= :target
    end
  end
end
