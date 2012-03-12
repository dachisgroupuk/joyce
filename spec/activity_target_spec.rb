require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::ActivityTarget do
  
  describe ".new" do
    it { Joyce::ActivityTarget.new.name.should == :target }
    
    context "with a name" do
      let(:name) { :testname }
      it { Joyce::ActivityTarget.new(:name => name).name.should == name }
    end
  end
  
end
