require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce do
  
  describe ".publish_activity" do
    before do
      @actor = create(:thing)
      @verb = Acted
    end
    
    subject { Joyce.publish_activity(:actor => @actor, :verb => @verb) }
    
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
    
    it "should serialize the verb" do
      subject
      Joyce::Activity.last.verb.should == @verb
    end
    
    context "when verb is not a Joyce::Verb" do
      before{ @verb = Object }
      it{ expect{ subject }.to raise_error ArgumentError }
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
    end
    
    it "should add activity to the default actor stream" do
      activity = subject
      Joyce::Stream.where(:owner_id => @actor.id, :name => nil).first.activities.should include(activity)
    end
    
    it "should add activity to the default verb stream" do
      activity = subject
      Joyce::Stream.where(:owner_type => @verb.to_s, :name => nil).first.activities.should include(activity)
    end
    
    context "with an object" do
      before { @object = create(:thing) }
      subject { Joyce.publish_activity(:actor => @actor, :verb => @verb, :obj => @object) }
      
      it "should save the object" do
        subject.obj.should == @object
      end
      
      it "should add activity to the default object stream" do
        activity = subject
        Joyce::Stream.where(:owner_id => @object.id, :name => nil).first.activities.should include(activity)
      end
      
      context "when called for the first time" do
        it "should create the default object stream" do
          expect{
            subject
          }.to change{ Joyce::Stream.where(:owner_id => @object.id, :name => nil).count }.by(1)
        end
      end
    end
    
    context "with a target" do
      before { @target = create(:thing) }
      subject { Joyce.publish_activity(:actor => @actor, :verb => @verb, :target => @target) }
      
      it "should save the target" do
        subject.get_targets.should include(@target)
      end
      
      it "should add activity to the default target stream" do
        activity = subject
        Joyce::Stream.where(:owner_id => @target.id, :name => nil).first.activities.should include(activity)
      end
    end
    
    context "with :only parameter" do
      before do
        @object = create(:thing)
        @params = { :actor => @actor, :verb => @verb, :obj => @object }
      end
      
      only_values = [:actor, :verb, :obj]
      only_values.each do |only|
        context "with :only => :#{only}" do
          subject { Joyce.publish_activity(@params.merge(:only => only)) }

          it "should add activity to the default :#{only} stream" do
            expect{
              subject
            }.to change{ @params[only].activity_stream.all }
          end

          only_values.reject{ |i| i == only }.each do |neg_only|
            it "should not add activity to the default :#{neg_only} stream" do
              expect{
                subject
              }.not_to change{ @params[neg_only].activity_stream.all }
            end
          end
        end
      end
      
      only = [:actor, :verb]
      context "with :only => #{only.inspect}" do
        subject { Joyce.publish_activity(@params.merge(:only => only)) }

        it "should add activity to the default :actor stream" do
          expect{
            subject
          }.to change{ @params[:actor].activity_stream.all }
        end
        
        it "should add activity to the default :verb stream" do
          expect{
            subject
          }.to change{ @params[:verb].activity_stream.all }
        end

        it "should not add activity to the default :obj stream" do
          expect{
            subject
          }.not_to change{ @params[:obj].activity_stream.all }
        end
      end
    end
  end
  
end
