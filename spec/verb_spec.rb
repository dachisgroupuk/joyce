require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::Verb do
  
  describe ".activity_stream" do
    let(:thing) { create(:thing) }
    let(:verb) { Acted }
    
    context "with no streams" do
      it { verb.activity_stream.should be_empty }
    end
    
    context "with streams" do
      before do
        @thing_stream = Joyce::Stream.create(:owner => thing)
        @verb_stream = Joyce::Stream.create(:owner_type => verb.to_s)
      end
      
      it { verb.activity_stream.should be_empty }
      
      context "when the stream has activities" do
        before do
          @activities_in_stream = 2.times.map { create(:activity, :verb => verb) }
          @activities_out_of_stream = []
          @activities_out_of_stream << create(:activity)
          @verb_stream.activities << @activities_in_stream
          @thing_stream.activities << @activities_out_of_stream
        end
        
        it { verb.activity_stream.should == @activities_in_stream }
      end
    end
  end
  
end
