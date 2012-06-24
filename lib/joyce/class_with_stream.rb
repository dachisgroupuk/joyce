module Joyce
  
  module ClassWithStream
    # Returns all the activities in the instance stream.
    def activity_stream
      Joyce::Activity
        .joins("JOIN joyce_activities_streams AS jas ON joyce_activities.id = jas.activity_id")
        .joins("JOIN joyce_streams ON joyce_streams.id = jas.stream_id")
        .where("joyce_streams" => {:name => nil, :owner_type => self})
    end
  end
  
end
