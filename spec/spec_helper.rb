require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'joyce'

require 'generators/joyce/templates/migration'
require 'database_cleaner'
require 'ruby-debug'
require 'timecop'
require 'factory_girl'
FactoryGirl.find_definitions

# Migrations
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'development.db')
AddJoyceTables.up

# Fixtures
class Thing < ActiveRecord::Base
  acts_as_joyce
end
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS `things`")
ActiveRecord::Base.connection.create_table(:things) do |t|
    t.string :name
    t.timestamps
end

class Person < ActiveRecord::Base
  acts_as_joyce
end
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS `people`")
ActiveRecord::Base.connection.create_table(:people) do |t|
    t.string :name
    t.timestamps
end

class Acted < Joyce::Verb; end

# support
class Time
  class << self
    alias_method :old_now, :now
    def now
      old_now.round(0)
    end
  end
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
  
  # Enable factory girl shorthand (e.g. use create(:model) instead of FactoryGirl.create(:model))
  config.include FactoryGirl::Syntax::Methods
end
