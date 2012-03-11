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
    
    Activity.create(:actor => args[:actor], :verb => args[:verb], :obj => args[:obj])
  end
end
