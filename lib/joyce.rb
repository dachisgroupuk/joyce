require "joyce/version"
require 'joyce/activity'
require 'joyce/stream'
require 'joyce/behaviour'

if defined?(ActiveRecord)
  ActiveRecord::Base.send(:include, Joyce::Behaviour)
end

module Joyce
  def self.publish_activity(args)
    raise ArgumentError.new("An actor must be specified for the Activity") unless args[:actor]
    raise ArgumentError.new("A verb must be specified for the Activity") unless args[:verb]
    
    activity = Activity.create(:actor => args[:actor], :verb => args[:verb], :obj => args[:obj])
    
    actor = args[:actor]
    actor_stream = Joyce::Stream.find_or_create_by_owner(actor)
    actor_stream.activities << activity
    
    activity
  end
end
