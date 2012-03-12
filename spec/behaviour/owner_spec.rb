require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Joyce::Behaviour::Owner do

  describe "#activity_stream" do
    let(:owner) { Thing.create }
    
    context "when the stream does not exist" do
      it { owner.activity_stream.should be_empty }
    end
    
    context "when the stream already exists" do
      before { @stream = Joyce::Stream.create(:owner => owner) }
      
      it { owner.activity_stream.should be_empty }
      
      context "when the stream has activities" do
        before do
          @activity = Joyce::Activity.create(:actor => Thing.create, :verb => "did", :obj => Thing.create)
          @stream.activities << @activity
        end
        
        it { owner.activity_stream.should == [@activity] }
      end
    end
  end

end
