# Joyce

A gem to manage activity streams (consciousness optional).

## Installation

Add this line to your application's Gemfile:

    gem 'joyce'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install joyce

## Configuration

Just add `act_as_joyce` in your models to enable activity streaming for them. E.g.:

    class Person < Activerecord::Base
      act_as_joyce
    end

This will add to the model methods such as `activity_stream`.

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

Once a model has been enabled by specifying `act_as_joyce`, it will have an activity stream.

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
