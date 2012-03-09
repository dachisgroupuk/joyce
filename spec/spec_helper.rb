require "rubygems"
require "bundler"
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'generators/joyce/templates/migration'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'development.db')
AddJoyceTables.up
