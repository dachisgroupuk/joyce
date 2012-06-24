module Joyce
  module Scopes
    # Returns activities created since the specified time.
    # 
    # @param since [Time] the starting time.
    def since(time)
      self.where(["joyce_activities.created_at > ?", time])
    end
    
    # Returns activities having the specified instance as an actor.
    # 
    # @param actor [Behaviour::Owner]
    def with_actor(actor)
      self.where(:actor_id => actor.id, :actor_type => actor.class.to_s)
    end
    
    # Returns activities having any instance other than the one specified as an actor.
    # 
    # @param actor [Behaviour::Owner]
    def without_actor(actor)
      self.where(["actor_id <> ? OR actor_type <> ?", actor.id, actor.class.to_s])
    end
    
    # Returns activities having the specified instance as an object.
    # 
    # @param object [Behaviour::Owner]
    def with_object(object)
      self.where(:obj_id => object.id, :obj_type => object.class.to_s)
    end
    
    # Returns activities having any instance other than the one specified as an object.
    # 
    # @param object [Behaviour::Owner]
    def without_object(object)
      self.where(["obj_id IS NULL OR obj_id <> ? OR obj_type <> ?", object.id, object.class.to_s])
    end
    
    # Returns activities having the specified verb.
    # 
    # @param actor [Verb]
    def with_verb(verb)
      self.where(:verb => verb.to_s)
    end
    
    # Returns activities having any verb other than the one specified.
    # 
    # @param verb [Verb]
    def without_verb(verb)
      self.where(["verb <> ?", verb.to_s])
    end
    
    # Returns activities having the specified instance as any of the targets.
    # 
    # @param target [Behaviour::Owner]
    def with_target(target)
      self
        .joins("JOIN joyce_activities_targets ON joyce_activities_targets.activity_id = id")
        .where(:joyce_activities_targets => {:target_id => target.id, :target_type => target.class.to_s})
    end
    
    # Returns activities having any instance other than the one specified as a target.
    # 
    # @param target [Behaviour::Owner]
    def without_target(target)
      self
        .joins("LEFT JOIN joyce_activities_targets ON joyce_activities_targets.activity_id = id")
        .where(["target_id IS NULL OR target_id <> ? OR target_type <> ?", target.id, target.class.to_s])
    end
    
    # Returns activities having the specified instance as one of its components (actor, verb, object, targets).
    # 
    # @param component [Behaviour::Owner, Verb]
    def with_component(component)
      id = component.respond_to?(:id) ? component.id : nil
      klass = component.is_a?(Class) ? component.to_s : component.class.to_s
      queries = arel_component_queries(id, klass)
      
      self
        .joins("LEFT JOIN joyce_activities_targets ON joyce_activities_targets.activity_id = id")
        .where(queries[:actor].or(queries[:verb]).or(queries[:object]).or(queries[:target]))
    end
    
    
    private
    
    def arel_instance_query(type, id, klass, table=nil)
      table ||= Joyce::Activity.arel_table
      table["#{type.to_s}_id"].eq(id).and(table["#{type.to_s}_type"].eq(klass))
    end
    
    def arel_component_queries(id, klass)
      activity_table = Joyce::Activity.arel_table
      jat_table = Arel::Table.new(:joyce_activities_targets)
      
      queries = {
        :actor  => arel_instance_query(:actor, id, klass, activity_table),
        :verb   => activity_table[:verb].eq(klass),
        :object => arel_instance_query(:obj, id, klass, activity_table),
        :target => arel_instance_query(:target, id, klass, jat_table)
      }
    end
  end
end
