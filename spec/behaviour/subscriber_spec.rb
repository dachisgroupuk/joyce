require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Joyce::Behaviour::Subscriber do
  
  let(:subscriber) { create(:thing) }
  
  it { subscriber.stream_subscriptions.should be_empty }
  
  describe "#subscribe_to" do
    context "when not subscribed" do
      shared_examples_for "a subscription creator" do
        it "should add a subscription" do
          expect{
            subscriber.subscribe_to(@producer)
          }.to change{ subscriber.stream_subscriptions.count }.by(1)
        end

        it "should save started_at" do
          time = Time.now
          Timecop.freeze(time) { subscriber.subscribe_to(@producer) }

          subscriber.stream_subscriptions.last.started_at.should == time
        end

        it "should not save ended_at" do
          subscriber.subscribe_to(@producer)
          subscriber.stream_subscriptions.last.ended_at.should be_nil
        end
      end

      context "with stream as a parameter" do
        let(:stream) { Joyce::Stream.create(:owner => create(:thing)) }
        before{ @producer = stream }

        it_should_behave_like "a subscription creator"
      end

      context "with model instance as a parameter" do
        let(:model) { create(:thing) }

        context "when model instance has got a stream" do
          before{ @stream = Joyce::Stream.create(:owner => model) }
          before{ @producer = model }

          it_should_behave_like "a subscription creator"

          it "should save the model stream" do
            subscriber.subscribe_to(model)
            subscriber.stream_subscriptions.last.stream.should == @stream
          end
        end
      end

      context "with wrong parameter" do
        it{ expect{ subscriber.subscribe_to(Object.new) }.to raise_error ArgumentError }
      end
    end
    
    context "when subscribed" do
      let(:model) { create(:thing) }
      before do
        @stream = Joyce::Stream.create(:owner => model)
        subscriber.subscribe_to(@stream)
      end
      
      it{ expect{ subscriber.subscribe_to(@stream) }.to raise_error Joyce::DuplicateSubscriptionError }
    end
  end
  
  describe "#unsubscribe_from" do
    context "when subscribed" do
      let(:model) { create(:thing) }
      before do
        @stream = Joyce::Stream.create(:owner => model)
        subscriber.subscribe_to(@stream)
      end
      
      context "with stream as a parameter" do
        before{ @producer = @stream }

        it "should save ended_at" do
          time = Time.now
          Timecop.freeze(time) { subscriber.unsubscribe_from(@producer) }

          subscriber.stream_subscriptions.last.ended_at.should == time
        end
      end

      context "with model instance as a parameter" do
        before{ @producer = model }

        it "should save ended_at" do
          time = Time.now
          Timecop.freeze(time) { subscriber.unsubscribe_from(@producer) }

          subscriber.stream_subscriptions.last.ended_at.should == time
        end
      end

      context "with wrong parameter" do
        it{ expect{ subscriber.unsubscribe_from(Object.new) }.to raise_error ArgumentError }
      end
    end
    
    context "when not subscribed" do
      let(:stream) { Joyce::Stream.create(:owner => create(:thing)) }
      it{ expect{ subscriber.unsubscribe_from(stream) }.to raise_error Joyce::NoSubscriptionError }
    end
  end
  
end
