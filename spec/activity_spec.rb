require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::Activity do
  
  describe "validation" do
    context "with missing parameters" do
      [
        {:verb => Acted},
        {:actor => Thing.create(:name => "Ulysses")}
      ].each do |params|
        context "with #{params}" do
          it { Joyce::Activity.new(params).should_not be_valid }
        end
      end
    end
  end
  
  describe "#get_targets" do
    let(:activity) { create(:activity) }
    it { activity.get_targets.should be_empty }
    
    context "with default target" do
      before do
        @default_target = build(:thing)
        Joyce::ActivityTarget.create(:activity => activity, :target => @default_target)
      end
      
      it { activity.get_targets.should == [@default_target] }
    end
    
    context "with named target" do
      before do
        @test_target = build(:thing)
        Joyce::ActivityTarget.create(:activity => activity, :target => @test_target, :name => :test)
      end
      
      it { activity.get_targets(:test).should == [@test_target] }
    end
    
    context "with array targets" do
      before do
        @test_targets = 2.times.map{ |i| build(:thing) }
        @test_targets.each do |target|
          Joyce::ActivityTarget.create(:activity => activity, :target => target, :name => :test)
        end
      end
      
      it { activity.get_targets(:test).should == @test_targets }
    end
  end
  
  describe "#set_targets" do
    let(:activity) { create(:activity) }
    let(:thing) { build(:thing) }
    
    context "when param is not a hash" do
      it { expect{ activity.set_targets(thing) }.to raise_error ArgumentError }
    end
    
    it "should set the target" do
      expect{
        activity.set_targets(:thing => thing)
      }.to change{ activity.get_targets(:thing) }.to([thing])
    end
    
    context "when hash value is an array" do
      let(:things) { 2.times.map{ |i| create(:thing) } }
      
      it "should set the targets" do
        expect{
          activity.set_targets(:things => things)
        }.to change{ activity.get_targets(:things) }.to(things)
      end
      
      context "when empty" do
        it "should not do anything" do
          expect{
            activity.set_targets(:things => [])
          }.not_to change{ activity.get_targets(:things) }
        end
      end
    end
    
  end
  
  describe "scopes" do
    describe "#since" do
      before do
        Timecop.travel(2.weeks.ago) do
          @activity_to_drop = create(:activity)
        end
        @activity_to_show = create(:activity)
      end
      
      it { Joyce::Activity.since(1.week.ago).should == [@activity_to_show] }
    end
  end
  
  describe "#verb=" do
    before{ @activity = Joyce::Activity.new }
    
    context "with a class" do
      before{ @activity.verb = Object }
      
      it{ @activity.read_attribute(:verb).should == "Object" }
    end
    
    context "with nil" do
      before{ @activity.verb = nil }
      
      it { @activity.read_attribute(:verb).should be_nil }
    end
  end
  
  describe "#verb" do
    before{ @activity = Joyce::Activity.new }
    
    context "with a class" do
      before{ @activity.verb = Object }
      
      it{ @activity.verb.should == Object }
    end
    
    context "with nil" do
      before{ @activity.verb = nil }
      
      it { @activity.verb.should be_nil }
    end
  end
  
end
