class JoyceGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  source_root File.expand_path('../templates', __FILE__)

  def generate_migration
    migration_template "migration.rb", "db/migrate/add_joyce_tables.rb"
  end
  
  # TODO: make this ORM-independent (assuming we can't get rid of it entirely)
  def self.next_migration_number(dirname)
    require 'rails/generators/active_record'
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end
end
