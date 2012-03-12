require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::Activity do
  
  describe "validation" do
    context "with missing parameters" do
      [
        {:verb => "fooled"},
        {:actor => Thing.create(:name => "Ulysses")}
      ].each do |params|
        context "with #{params}" do
          it { Joyce::Activity.new(params).should_not be_valid }
        end
      end
    end
  end
  
  describe "#get_targets" do
    let(:activity) { Joyce::Activity.create(:actor => Thing.new, :verb => "did") }
    it { activity.get_targets.should be_empty }
    
    context "when targets exist" do
      before do
        @default_target = Thing.new
        Joyce::ActivityTarget.create(:activity => activity, :target => @default_target)
        @test_target = Thing.new
        Joyce::ActivityTarget.create(:activity => activity, :target => @test_target, :name => :test)
      end
      
      it { activity.get_targets.should == [@default_target]}
      it { activity.get_targets(:test).should == [@test_target]}
    end
  end
  
  describe "#set_targets" do
    let(:activity) { Joyce::Activity.create(:actor => Thing.new, :verb => "did") }
    let(:thing) { Thing.new }
    
    context "when param is not a hash" do
      it { expect{ activity.set_targets(thing) }.to raise_error ArgumentError }
    end
    
    it "should set the target" do
      expect{
        activity.set_targets(:thing => thing)
      }.to change{ activity.get_targets(:thing) }.to([thing])
    end
    
  end
  
  describe "scopes" do
    describe "#since" do
      before do
        Timecop.travel(2.weeks.ago) do
          @activity_to_drop = Joyce::Activity.create(:actor => Thing.new, :verb => "did")
        end
        @activity_to_show = Joyce::Activity.create(:actor => Thing.new, :verb => "did")
      end
      
      it { Joyce::Activity.since(1.week.ago).should == [@activity_to_show] }
    end
  end
  
end
