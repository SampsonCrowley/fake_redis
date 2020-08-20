# TinyFakeRedis

Pretend to Access a Redis Server

This gem mimics the calls of `redis-rb` to allow running commands in development and test environments without the need to run a redis server instance

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tiny_fake_redis"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tiny_fake_redis

## Usage
Create an instance

```ruby
redis = TinyFakeRedis.new
```

Treat it the same as an open redis-rb connection

```ruby
redis.set(:asdf, :asdf)
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SampsonCrowley/tiny_fake_redis


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
