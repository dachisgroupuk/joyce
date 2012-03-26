module Joyce
  module Scopes
    def since(time)
      self.where(["joyce_activities.created_at > ?", time])
    end
    
    def with_actor(actor)
      self.where(:actor_id => actor.id, :actor_type => actor.class.to_s)
    end
    
    def with_object(object)
      self.where(:obj_id => object.id, :obj_type => object.class.to_s)
    end
    
    def with_verb(verb)
      self.where(:verb => verb.to_s)
    end
    
    def with_target(target)
      self
        .joins("JOIN joyce_activities_targets ON joyce_activities_targets.activity_id = id")
        .where(:joyce_activities_targets => {:target_id => target.id, :target_type => target.class.to_s})
    end
  end
end
