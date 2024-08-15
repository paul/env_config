# EnvConfig

Safer and convenient access to ENV variables in production applications.

EnvConfig wraps ENV, and provides some nice helpers and extensions. 

1. `#fetch!`

Works just like `Hash#fetch` (or `ENV.fetch`), but raises an exception in production when attempting
to access the value, rather than using the fallback. This causes your application to blow up early
with a clear error message when you forgot to add the ENV var, rather than failing later with an
opaque error.

Example:

```ruby
EnvConfig.fetch("HOST", "localhost") # => "localhost"

# With RAILS_ENV=production (or RACK_ENV)
EnvConfig.fetch("HOST", "localhost") # => ProductionKeyError: Environment Variable HOST is required
```

2. `#fetch?`

When using Rails, casts the value to a boolean, using the same cast helper as Params. So `"f"`,
`"false"`, `"0"`, etc all become `false`, anything else is `true`.

3. Extensions

Comes with optional helpers when running with Rails and/or Heroku. PRs welcomed for other
environments.

```ruby

EnvConfig.load_extensions :rails, :heroku

EnvConfig.heroku? # true when running in a Heroku Dyno

EnvConfig.dyno # Parses eg 'worker.1` into "worker"
EnvConfig.dyno.worker? # Also works
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'env_config'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install env_config

## Usage

In Rails, I like to create a separate config with custom extensions for my app:

```ruby
# lib/env_config.rb
module MyAppEnvConfig
  def my_helper
    @my_value ||= ActiveSupport::StringInquirer.new(fetch('MY_VAR') { local? ? 'localhost' : 'myapp.com' })
  end
end

EnvConfig.register_extension(:my_app) do
  EnvConfig::Config.prepend MyAppEnvConfig
end

EnvConfig.load_extensions :rails, :my_app
```

Then this needs to be pulled in early in the application boot process. I like putting it in
`application.rb`, right after the `Bundler.require` step.

```ruby
# config/application.rb

# ...
Bundler.require(*Rails.groups)

# Add this right after Bundler
require_relative '../lib/env_config'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paul/env_config. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/env_config/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EnvConfig project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/env_config/blob/master/CODE_OF_CONDUCT.md).
