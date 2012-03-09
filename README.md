# Joyce

A gem to manage activity streams (consciousness optional).

## Installation

Add this line to your application's Gemfile:

    gem 'joyce'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install joyce

## Usage

Basic usage:

    Joyce.publish_activity(:actor => actor, :verb => verb, :obj => object)

The parameter names conform to the [JSON Activity Streams 1.0](http://activitystrea.ms/specs/json/1.0/) specification (`:obj` is used instead of `:object`, which is a reserved word).

## Testing

Execute:

    $ rspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
