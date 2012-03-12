require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Joyce::Behaviour::Owner do

  describe "#activity_stream" do
    let(:owner) { Thing.create }
    
    context "when the stream does not exist" do
      it { owner.activity_stream.should be_empty }
    end
    
    context "when the stream already exists" do
      before { @stream = Joyce::Stream.create(:owner => owner) }
      
      it { owner.activity_stream.should be_empty }
      
      context "when the stream has activities" do
        before do
          @activity = Joyce::Activity.create(:actor => Thing.create, :verb => "did", :obj => Thing.create)
          @stream.activities << @activity
        end
        
        it { owner.activity_stream.should == [@activity] }
      end
    end
  end
  
  describe ".activity_stream" do
    let(:thing) { Thing.create }
    let(:person) { Person.create }
    
    context "when the stream does not exist" do
      it { Thing.activity_stream.should be_empty }
    end
    
    context "when the stream already exists" do
      before do
        @thing_stream = Joyce::Stream.create(:owner => thing)
        @person_stream = Joyce::Stream.create(:owner => person)
      end
      
      it { Thing.activity_stream.should be_empty }
      
      context "when the stream has activities" do
        before do
          @activities_in_stream = 2.times.map { Joyce::Activity.create(:actor => thing, :verb => "did") }
          @activities_out_of_stream = []
          @activities_out_of_stream << Joyce::Activity.create(:actor => person, :verb => "did")
          @thing_stream.activities << @activities_in_stream
          @person_stream.activities << @activities_out_of_stream
        end
        
        it { Thing.activity_stream.should == @activities_in_stream }
      end
    end
  end

end
