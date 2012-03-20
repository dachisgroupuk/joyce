module Joyce
  module Behaviour
    
    module Owner
      def self.included(base)
        base.extend ClassWithStream
      end
      
      def activity_stream
        stream = streams.where(:name => nil).first
        return [] if stream.nil?
        stream.activities
      end
    end
    
  end
end
