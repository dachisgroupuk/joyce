require "joyce/version"
require 'joyce/activity'

module Joyce
  def self.publish_activity(args)
    Activity.create(:actor => args[:actor], :verb => args[:verb], :obj => args[:obj])
  end
end
