require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::Stream do
  describe "validation" do
    context "with missing parameters" do
      it { Joyce::Stream.new.should_not be_valid }
    end
  end
  
  describe ".default" do
    let(:params) { { :owner => create(:thing) } }
    
    it "should create a new stream" do
      Joyce::Stream.should_receive(:new).with(params)
      Joyce::Stream.default(params)
    end
  end
  
  describe ".find_or_create_by_owner" do
    context "with owner instance" do
      let(:owner) { create(:thing) }

      context "when stream does not exist" do
        it "should create stream" do
          Joyce::Stream.should_receive(:create).with(:owner_id => owner.id, :owner_type => owner.class.to_s)
          Joyce::Stream.find_or_create_by_owner(owner)
        end
      end

      context "when stream does exist" do
        before { @stream = Joyce::Stream.create(:owner => owner) }

        it "should return stream" do
          Joyce::Stream.find_or_create_by_owner(owner).should == @stream
        end

        it "should not create stream" do
          Joyce::Stream.should_not_receive(:create)
          Joyce::Stream.find_or_create_by_owner(owner)
        end
      end
    end
    
    context "with verb class" do
      let(:verb) { Acted }

      context "when stream does not exist" do
        it "should create stream" do
          Joyce::Stream.should_receive(:create).with(:owner_type => verb.to_s)
          Joyce::Stream.find_or_create_by_owner(verb)
        end
      end

      context "when stream does exist" do
        before { @stream = Joyce::Stream.create(:owner_type => verb.to_s) }

        it "should return stream" do
          Joyce::Stream.find_or_create_by_owner(verb).should == @stream
        end

        it "should not create stream" do
          Joyce::Stream.should_not_receive(:create)
          Joyce::Stream.find_or_create_by_owner(verb)
        end
      end
    end
  end
  
  describe "#destroy" do
    let(:stream) { create(:stream) }
    let(:owner) { stream.owner }
    subject{ stream.destroy }
    
    it "should destroy the relationship with the owner" do
      expect{
        subject
      }.to change{ owner.streams.count }.by(-1)
    end
    
    it "should preserve the owner" do
      expect{
        subject
      }.not_to change { owner.class.count }
    end
    
    context "with a subscriber" do
      let(:subscriber) { create(:thing) }
      before{ subscriber.subscribe_to(stream) }
      
      it "should destroy the subscription" do
        expect{
          subject
        }.to change{ Joyce::StreamSubscriber.count }.by(-1)
      end
    end
    
    context "with an activity" do
      let(:activity) { create(:activity) }
      before{ stream.activities << activity }
      
      it "should destroy the relationship" do
        expect{
          subject
        }.to change{ activity.streams.count }.by(-1)
      end
      
      it "should preserve the activity" do
        expect{
          subject
        }.not_to change{ Joyce::Activity.count }
      end
    end
  end
  
end
