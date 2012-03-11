require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'joyce'

require 'generators/joyce/templates/migration'
require 'database_cleaner'


# Migrations
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'development.db')
AddJoyceTables.up

# Fixtures
class Thing < ActiveRecord::Base
  
end
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS `things`")
ActiveRecord::Base.connection.create_table(:things) do |t|
    t.string :name
    t.timestamps
end

RSpec.configure do |config|
  # Prettyfying
  config.color_enabled  = true
  config.formatter      = 'documentation'
  
  # Cleaning database
  config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
end
