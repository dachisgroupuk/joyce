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
    let(:owner) { create(:thing) }
    
    context "when stream does not exist" do
      it "should create stream" do
        Joyce::Stream.should_receive(:create).with(:owner => owner)
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
end
