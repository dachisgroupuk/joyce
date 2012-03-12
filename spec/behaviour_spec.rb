require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::Behaviour do
  it "should add act_as_joyce method" do
    class JoyceTestDummy < ActiveRecord::Base; end
    JoyceTestDummy.methods.should include(:act_as_joyce)
  end
  
  describe ".act_as_joyce" do
    it "should add a relationship with streams" do
      Thing.new.methods.should include(:streams)
    end
    
    it "should turn model into an owner" do
      Thing.new.methods.should include(:activity_stream)
    end
  end

end
