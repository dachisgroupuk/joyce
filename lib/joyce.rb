require "joyce/version"
require 'joyce/activity'
require 'joyce/stream'
require 'joyce/behaviour'
require 'joyce/behaviour/owner'

if defined?(ActiveRecord)
  ActiveRecord::Base.send(:include, Joyce::Behaviour)
end

module Joyce
  def self.publish_activity(args)
    raise ArgumentError.new("An actor must be specified for the Activity") unless args[:actor]
    raise ArgumentError.new("A verb must be specified for the Activity") unless args[:verb]
    
    actor = args[:actor]
    obj = args[:obj]
    
    activity = Activity.create(:actor => actor, :verb => args[:verb], :obj => obj)
    
    add_to_stream_owned_by(actor, activity)
    add_to_stream_owned_by(obj, activity) unless obj.nil?
    
    activity
  end
  
  
  private
  
  def self.add_to_stream_owned_by(stream_owner, activity)
    stream = Joyce::Stream.find_or_create_by_owner(stream_owner)
    stream.activities << activity
  end
end
