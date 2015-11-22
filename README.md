[![Gem Version](https://badge.fury.io/rb/vibrant-rb.svg)](https://badge.fury.io/rb/vibrant-rb)

# Vibrant::Rb

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/vibrant/rb`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vibrant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vibrant

## Usage

```

# path or file
vibrant = Vibrant.read('images/octocat.png')

# get colors
vibrant = vibrant.vibrant.hex
muted = vibrant.muted.hex
dark_vibrant = vibrant.dark_vibrant.hex
dark_muted = vibrant.dark_muted.hex
light_vibrant = vibrant.light_vibrant.hex
light_muted = vibrant.light_muted.hex
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vibrant-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

