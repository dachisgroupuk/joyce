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
    
    def self.find_or_create_by_owner(owner)
      stream = where(:owner_id => owner.id, :owner_type => owner.class).first
      if stream.nil?
        create(:owner => owner)
      else
        stream
      end
    end
  end
end
