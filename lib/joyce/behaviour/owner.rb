module Joyce
  module Behaviour
    
    module Owner
      def activity_stream
        stream = streams.where(:name => nil).first
        return [] if stream.nil?
        stream.activities
      end
    end
    
  end
end
