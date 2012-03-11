require 'active_record'

module Joyce
  class Stream < ActiveRecord::Base
    self.table_name = 'joyce_streams'
    
    belongs_to :owner, :polymorphic => true
    has_and_belongs_to_many :activities, :join_table => "joyce_activities_streams"
    
    validates_presence_of :owner
    
    def self.default(params)
      new params
    end
  end
end
