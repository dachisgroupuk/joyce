require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Joyce::Behaviour::Owner do

  describe "#activity_stream" do
    let(:owner) { create(:thing) }
    
    context "when the stream does not exist" do
      it { owner.activity_stream.should be_empty }
      it { owner.activity_stream.should be_a(ActiveRecord::Relation) }
    end
    
    context "when the stream already exists" do
      before { @stream = Joyce::Stream.create(:owner => owner) }
      
      it { owner.activity_stream.should be_empty }
      it { owner.activity_stream.should be_a(ActiveRecord::Relation) }
      
      context "when the stream has activities" do
        before do
          @activity = create(:activity)
          @stream.activities << @activity
        end
        
        it { owner.activity_stream.should == [@activity] }
        it { owner.activity_stream.should be_a(ActiveRecord::Relation) }
      end
    end
  end
  
  describe ".activity_stream" do
    let(:thing) { create(:thing) }
    let(:person) { create(:person) }
    
    context "when the stream does not exist" do
      it { Thing.activity_stream.should be_empty }
      it { Thing.activity_stream.should be_a(ActiveRecord::Relation) }
    end
    
    context "when the stream already exists" do
      before do
        @thing_stream = Joyce::Stream.create(:owner => thing)
        @person_stream = Joyce::Stream.create(:owner => person)
      end
      
      it { Thing.activity_stream.should be_empty }
      it { Thing.activity_stream.should be_a(ActiveRecord::Relation) }
      
      context "when the stream has activities" do
        before do
          @activities_in_stream = 2.times.map { create(:activity, :actor => thing) }
          @activities_out_of_stream = []
          @activities_out_of_stream << create(:activity, :actor => person)
          @thing_stream.activities << @activities_in_stream
          @person_stream.activities << @activities_out_of_stream
        end
        
        it { Thing.activity_stream.should == @activities_in_stream }
        it { Thing.activity_stream.should be_a(ActiveRecord::Relation) }
      end
    end
  end
  
  describe "#destroy" do
    let(:owner) { create(:thing) }
    
    context "when the stream exists" do
      before { @stream = Joyce::Stream.create(:owner => owner) }
      
      it "should destroy the stream" do
        expect{
          owner.destroy
        }.to change{ Joyce::Stream.count }.by(-1)
      end
    end
  end

end
