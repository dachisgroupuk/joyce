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
        before{ @producer = model }

        context "when model instance has got a stream" do
          before{ @stream = Joyce::Stream.create(:owner => model) }

          it_should_behave_like "a subscription creator"

          it "should save the model stream" do
            subscriber.subscribe_to(model)
            subscriber.stream_subscriptions.last.stream.should == @stream
          end
        end
        context "when model instance doesn't have a stream yet" do
          it_should_behave_like "a subscription creator"
          it "should create a stream for the model instance" do
            expect { subscriber.subscribe_to(model) }.to change {model.streams.count }.by(1)
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
  
  describe "#subscribed_activity_stream" do
    context "when not subscribed" do
      it { subscriber.subscribed_activity_stream.should be_empty }
    end
    
    context "when subscribed to multiple streams" do
      before do
        @thing_stream = Joyce::Stream.create(:owner => create(:thing))
        @person_stream = Joyce::Stream.create(:owner => create(:person))
        Timecop.travel(1.month.ago) do
          subscriber.subscribe_to(@thing_stream)
          subscriber.subscribe_to(@person_stream)
        end
      end
      
      it { subscriber.subscribed_activity_stream.should be_empty }
      
      context "when one of the streams has activities from after subscribing" do
        before do
          @activity = create(:activity)
          @thing_stream.activities << @activity
        end
        
        it "should show activities from the stream" do
          subscriber.subscribed_activity_stream.should == [@activity]
        end
      end
      
      context "when all streams have activities from after subscribing" do
        before do
          @new_activity = create(:activity)
          @person_stream.activities << @new_activity
          
          Timecop.travel(2.weeks.ago) do
            @old_activity = create(:activity)
            @thing_stream.activities << @old_activity
          end
        end
        
        it "should show activities from all streams" do
          subscriber.subscribed_activity_stream.should == [@new_activity, @old_activity]
        end
        
        context "when unsubscribing" do
          before do
            Timecop.travel(1.week.ago) do
              subscriber.unsubscribe_from(@person_stream)
              subscriber.unsubscribe_from(@thing_stream)
            end
          end
          
          it "should show activities from before unsubscribing" do
            subscriber.subscribed_activity_stream.should include(@old_activity)
          end
          
          it "should not show activities from after unsubscribing" do
            subscriber.subscribed_activity_stream.should_not include(@new_activity)
          end
          
          context "when subscribing again" do
            before do
              Timecop.travel(1.day.ago) do
                subscriber.subscribe_to(@person_stream)
              end
            end
            
            it "should show activities from after subscribing again" do
              subscriber.subscribed_activity_stream.should include(@new_activity)
            end
          end
        end
        
        context "with an activity from before subscribing" do
          before do
            Timecop.travel(1.year.ago) do
              @oldest_activity = create(:activity)
              @thing_stream.activities << @oldest_activity
            end
          end
          
          it "should not show activities from before subscribing" do
            subscriber.subscribed_activity_stream.should_not include(@oldest_activity)
          end
        end
      end
    end
  end
  
end
