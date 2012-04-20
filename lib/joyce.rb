require "joyce/version"
require "joyce/class_with_stream"
require 'joyce/scopes'
require 'joyce/activity'
require 'joyce/stream'
require 'joyce/activity_target'
require 'joyce/behaviour'
require 'joyce/behaviour/entity'
require 'joyce/behaviour/owner'
require 'joyce/behaviour/subscriber'
require 'joyce/stream_subscriber'
require 'joyce/verb'

if defined?(ActiveRecord)
  ActiveRecord::Base.send(:include, Joyce::Behaviour)
end

module Joyce
  # These 2 extend are needed to make this module observable
  extend ActiveModel::Observing::ClassMethods
  extend ActiveSupport::DescendantsTracker
  
  def self.publish_activity(args)
    raise ArgumentError.new("An actor must be specified for the Activity") unless args[:actor]
    raise ArgumentError.new("A verb must be specified for the Activity") unless args[:verb]
    raise ArgumentError.new("Verb must be a Joyce::Verb") unless args[:verb].is_a?(Class) && args[:verb] < Joyce::Verb
    
    # Pop all the known params from args until only targets remain
    actor = args.delete(:actor)
    verb = args.delete(:verb)
    obj = args.delete(:obj)
    only = args.delete(:only)
    
    activity = Activity.create(:actor => actor, :verb => verb, :obj => obj)
    activity.set_targets(args)
    
    streams_whitelist = init_streams_whitelist(only)
    
    add_to_stream_owned_by(verb, activity) if streams_whitelist.include?(:verb)
    add_to_stream_owned_by(actor, activity) if streams_whitelist.include?(:actor)
    add_to_stream_owned_by(obj, activity) if streams_whitelist.include?(:obj) unless obj.nil?
    args.each do |name, target|
      if target.is_a?(Array)
        target.each do |t|
          add_to_stream_owned_by(t, activity)
        end
      else
        add_to_stream_owned_by(target, activity)
      end
    end
    
    notify_observers(:after_publish, activity)
    
    activity
  end
  
  
  private
  
  def self.add_to_stream_owned_by(stream_owner, activity)
    stream = Joyce::Stream.find_or_create_by_owner(stream_owner)
    stream.activities << activity
  end
  
  def self.init_streams_whitelist(only)
    only = [only] unless only.is_a?(Array) || only.nil?
    
    whitelist = [:actor, :verb, :obj]
    only.nil? ? whitelist : whitelist.select{ |item| only.include?(item) }
  end
end
