require "joyce/version"
require 'joyce/activity'
require 'joyce/stream'

module Joyce
  def self.publish_activity(args)
    raise ArgumentError.new("An actor must be specified for the Activity") unless args[:actor]
    raise ArgumentError.new("A verb must be specified for the Activity") unless args[:verb]
    
    Activity.create(:actor => args[:actor], :verb => args[:verb], :obj => args[:obj])
  end
end
