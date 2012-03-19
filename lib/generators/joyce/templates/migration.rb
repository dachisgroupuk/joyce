class AddJoyceTables < ActiveRecord::Migration
  def self.up
    create_table 'joyce_activities', :force => true do |t|
      t.string      'verb', :null => false
      t.references  :actor, :polymorphic => true, :null => false
      t.references  :obj, :polymorphic => true
      t.timestamps
    end
    add_index(:joyce_activities, :created_at)
    
    create_table 'joyce_streams', :force => true do |t|
      t.string      'name'
      t.references  :owner, :polymorphic => true, :null => false
      t.timestamps
    end
    add_index(:joyce_streams, :owner_type)
    add_index(:joyce_streams, [:owner_id, :owner_type])
    
    create_table 'joyce_activities_streams', :id => false, :force => true do |t|
      t.references  :activity, :null => false
      t.references  :stream, :null => false
    end
    add_index(:joyce_activities_streams, :activity_id)
    add_index(:joyce_activities_streams, :stream_id)
    
    create_table 'joyce_activities_targets', :id => false, :force => true do |t|
      t.string      'name'
      t.references  :activity, :null => false
      t.references  :target, :polymorphic => true, :null => false
    end
    
    create_table 'joyce_streams_subscribers', :force => true do |t|
      t.references  :subscriber, :polymorphic => true, :null => false
      t.references  :stream, :null => false
      t.datetime    'started_at', :null => false
      t.datetime    'ended_at'
    end
    add_index(:joyce_streams_subscribers, [:subscriber_id, :subscriber_type], :name => "index_joyce_streams_subscribers_on_subscriber")
    add_index(:joyce_streams_subscribers, :stream_id)
  end

  def self.down
    drop_table 'joyce_activities'
    drop_table 'joyce_streams'
    drop_table 'joyce_activities_streams'
    drop_table 'joyce_activities_targets'
    drop_table 'joyce_streams_subscribers'
  end
end
