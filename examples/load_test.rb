require 'joyce'

require 'generators/joyce/templates/migration'

class User < ActiveRecord::Base
  acts_as_joyce
end

class BlogPost < ActiveRecord::Base
  acts_as_joyce
end

class Liked < Joyce::Verb; end

def timed_block(title=nil, &block)
  puts "#{(title || "Executing code")}..."
  t = Time.now
  
  yield
  
  time = Time.now-t
  puts "\n-> done #{title.downcase} in #{time}s\n"
  return time
end

timed_block("Setting up database") do
  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'development.db')
  AddJoyceTables.up

  ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS `users`")
  ActiveRecord::Base.connection.create_table(:users) do |t|
      t.string :name
      t.timestamps
  end
  ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS `blog_posts`")
  ActiveRecord::Base.connection.create_table(:blog_posts) do |t|
      t.string :title
      t.timestamps
  end
end

USERS = 20 #1000
BLOG_POSTS = 10 #1000
SUBSCRIBED_USERS = 10 #100

users = blog_posts = []
timed_block("Generating content") do
  users = USERS.times.map{ |i| print "."; User.create(:name => "User #{i}") }
  blog_posts = BLOG_POSTS.times.map{ |i| print "."; BlogPost.create(:title => "Post #{i}") }
end

timed_block("Setting up subscriptions") do
  users.each do |user|
    users.sample(SUBSCRIBED_USERS).each do |sampled_user|
      print "."
      user.subscribe_to(sampled_user)
    end
  end
end

timed_block("Generating activities") do
  users.each do |user|
    blog_posts.each do |blog_post|
      print "."
      Joyce.publish_activity(:actor => user, :verb => Liked, :obj => blog_post)
    end
  end
end

timed_block("Getting subscribed activities") do
  user = users.sample
  activities = user.subscribed_activity_stream.all
  puts "#{user.name} has got #{activities.count} activities through their subscriptions"
end

timed_block("Getting verb activity stream") do
  activities = Liked.activity_stream.all
  puts "'Liked' verb has got #{activities.count} activities"
end

# puts 'RAM USAGE: ' + `vmmap #{Process.pid}`
