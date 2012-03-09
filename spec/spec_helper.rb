require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'joyce'

# Migrations
require 'generators/joyce/templates/migration'
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

# Prettyfying
RSpec.configure do |config|
  config.color_enabled  = true
  config.formatter      = 'documentation'
end
