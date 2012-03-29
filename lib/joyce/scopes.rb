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
