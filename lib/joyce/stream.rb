require 'active_record'

module Joyce
  class Stream < ActiveRecord::Base
    self.table_name = 'joyce_streams'
    
    belongs_to :owner, :polymorphic => true
    has_and_belongs_to_many :activities, :join_table => "joyce_activities_streams"
    
    validates_presence_of :owner_type
    
    def self.default(params)
      new params
    end
    
    def self.find_or_create_by_owner(owner)
      if owner.is_a?(Class)
        args = { :owner_type => owner.to_s }
      else
        args = { :owner_id => owner.id, :owner_type => owner.class.to_s }
      end
      
      stream = where(args).first
      if stream.nil?
        create(args)
      else
        stream
      end
    end
    
    def self.find_or_create_by_verb(verb)
      stream = where(:owner_type => verb.to_s).first
      if stream.nil?
        create(:owner_type => verb.to_s)
      else
        stream
      end
    end
  end
end
