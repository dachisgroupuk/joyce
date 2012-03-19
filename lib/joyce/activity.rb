require 'active_record'

module Joyce
  class Activity < ActiveRecord::Base
    self.table_name = 'joyce_activities'
    
    belongs_to :actor, :polymorphic => true
    belongs_to :obj, :polymorphic => true
    has_and_belongs_to_many :streams, :join_table => "joyce_activities_streams"
    has_and_belongs_to_many :targets, :join_table => "joyce_activities_targets"
    
    validates_presence_of :actor, :verb
    
    extend Joyce::Scopes
    
    def get_targets(name=:target)
      ActivityTarget.where(:name => name, :activity_id => id).map{ |at| at.target }
    end
    
    def set_targets(targets)
      raise ArgumentError.new("Parameter for set_targets should be a hash of type {:name => target}") unless targets.is_a?(Hash)
      
      targets.each do |name, target|
        ActivityTarget.create(:name => name, :activity => self, :target => target)
      end
    end
    
    def verb=(value)
      verb_value = value.nil? ? nil : value.to_s
      write_attribute(:verb, verb_value)
    end
    
    def verb
      verb_value = read_attribute(:verb)
      verb_value.nil? ? nil : verb_value.constantize
    end
  end
end
