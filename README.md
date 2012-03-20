# Joyce

A gem to manage activity streams (consciousness optional).


## Installation

Add this line to your application's Gemfile:

    gem 'joyce'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install joyce

### Rails Migration

To generate the migration file in Rails, run:

    $ rails generate joyce

This will generate a file in your `db/migrate/` folder. You will need to run `rake db:migrate` afterwards.


## Configuration

Just add `acts_as_joyce` in your models to enable activity streaming for them. E.g.:

    class Person < Activerecord::Base
      acts_as_joyce
    end

This will add to the model methods such as `activity_stream`.


## Concepts

The basic concepts in Joyce are the **activity** and the **stream**.

An **activity** is a trace of an action that happened in an application. It can usually be mapped to a simple sentence, such as _John logged in_ or _Jane added a comment to a post_. The verb identifies the activity, the subject identifies the actor and the other entities in the sentence represent other people or objects contributing to the activity.

A **stream** is a list of activities, usually presented in reverse chronological order. An activity can belong to multiple streams. In fact, by default, an activity belongs to the streams of all the entities involved in it: the activity _user#1 added comment#2 to post#3_ belongs to the stream for *user#1*, the one for *comment#2* and the one for *post#3*. It also belongs to the generic *User*, *Comment*, and *Post* streams.

An additional concept is the **subscription**. To make streams more manageable, it is possible to subscribe to multiple streams, in order to get a composite stream containing all the activities for them.


## Usage

Basic usage:

    Joyce.publish_activity(:actor => actor, :verb => verb, :obj => object)

The parameter names conform to the [JSON Activity Streams 1.0](http://activitystrea.ms/specs/json/1.0/) specification (`:obj` is used instead of `:object`, which is a reserved word).

### Publishing an activity

The `publish_activity` method accepts a hash of parameters, among which `:actor` and `:verb` are the only mandatory ones.

By default, the activity will be added to the stream for each model instance passed with the call (i.e. actor, object, targets). E.g.:

    person = Person.new
    activity = Joyce.publish_activity(:actor => person, :verb => "did")
    person.activity_stream # will return [activity]

### Activity stream

Once a model has been enabled by specifying `acts_as_joyce`, it will have an activity stream.

You can get all the activities for a specific model instance. E.g.:

    person.activity_stream

Or you can get all the activities for all instances of a model. E.g.:

    Person.activity_stream


## Testing

Execute:

    $ rspec


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
