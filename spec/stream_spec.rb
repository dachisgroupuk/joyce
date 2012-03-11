require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Joyce::Stream do
  describe "validation" do
    context "with missing parameters" do
      it { Joyce::Stream.new.should_not be_valid }
    end
  end
  
  describe ".default" do
    let(:params) { { :owner => Thing.create } }
    
    it "should create a new stream" do
      Joyce::Stream.should_receive(:new).with(params)
      Joyce::Stream.default(params)
    end
  end
end
