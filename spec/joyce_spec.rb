require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce do
  describe ".publish_activity" do
    before do
      @actor = Thing.create(:name => "Ulysses")
      @verb = "fooled"
      @object = Thing.create(:name => "Polyphemus")
    end
    
    it "should create an Activity" do
      expect{
        Joyce.publish_activity(:actor => @actor, :verb => @verb, :obj => @object)
      }.to change{ Joyce::Activity.count }.by(1)
    end
  end
  
  it "should have a method" do
    Joyce.methods.should include(:publish_activity)
  end
end
