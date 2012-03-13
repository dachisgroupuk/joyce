class AddJoyceTables < ActiveRecord::Migration
  def self.up
    create_table 'joyce_activities', :force => true do |t|
      t.string      'verb', :null => false
      t.references  :actor, :polymorphic => true, :null => false
      t.references  :obj, :polymorphic => true
      t.timestamps
    end
    
    create_table 'joyce_streams', :force => true do |t|
      t.string      'name'
      t.references  :owner, :polymorphic => true, :null => false
      t.timestamps
    end
    
    create_table 'joyce_activities_streams', :id => false, :force => true do |t|
      t.references  :activity, :null => false
      t.references  :stream, :null => false
    end
    
    create_table 'joyce_activities_targets', :id => false, :force => true do |t|
      t.string      'name'
      t.references  :activity, :null => false
      t.references  :target, :polymorphic => true, :null => false
    end
  end

  def self.down
    drop_table 'joyce_activities'
    drop_table 'joyce_streams'
    drop_table 'joyce_activities_streams'
    drop_table 'joyce_activities_targets'
  end
end
