require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce do
  
  describe ".publish_activity" do
    before do
      @actor = Thing.create(:name => "Ulysses")
      @verb = "fooled"
      @object = Thing.create(:name => "Polyphemus")
    end
    
    subject { Joyce.publish_activity(:actor => @actor, :verb => @verb, :obj => @object) }
    
    it "should create an Activity" do
      expect{
        subject
      }.to change{ Joyce::Activity.count }.by(1)
    end
    
    it "should return the activity" do
      subject.should == Joyce::Activity.last
    end
    
    it "should save the actor" do
      subject.actor.should == @actor
    end
    
    it "should save the verb" do
      subject.verb.should == @verb
    end
    
    it "should save the object" do
      subject.obj.should == @object
    end
    
    context "with missing parameters" do
      [
        {:verb => "fooled"},
        {:actor => Thing.create(:name => "Ulysses")}
      ].each do |params|
        context "with #{params}" do
          it{ expect{ Joyce.publish_activity(params) }.to raise_error ArgumentError }
        end
      end
    end
    
    context "when called for the first time" do
      it "should create the default actor stream" do
        expect{
          subject
        }.to change{ Joyce::Stream.where(:owner_id => @actor.id, :name => nil).count }.by(1)
      end
      
      it "should create the default object stream" do
        expect{
          subject
        }.to change{ Joyce::Stream.where(:owner_id => @object.id, :name => nil).count }.by(1)
      end
    end
    
    it "should add activity to the default actor stream" do
      activity = subject
      Joyce::Stream.where(:owner_id => @actor.id, :name => nil).first.activities.should include(activity)
    end
    
    it "should add activity to the default object stream" do
      activity = subject
      Joyce::Stream.where(:owner_id => @object.id, :name => nil).first.activities.should include(activity)
    end
  end
  
end
