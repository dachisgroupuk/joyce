class AddJoyceTables < ActiveRecord::Migration
  def self.up
    create_table 'joyce_activities', :force => true do |t|
      t.string   'verb', :null => false
      t.integer  'actor_id', :null => false
      t.string   'actor_type', :null => false
      t.integer  'obj_id'
      t.string   'obj_type'
      t.timestamps
    end
  end

  def self.down
    drop_table 'joyce_activities'
  end
end
