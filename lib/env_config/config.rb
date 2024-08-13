# frozen_string_literal: true

require "forwardable"
require "dry/core/extensions"

class EnvConfig
  # Exception raised when key is missing from ENV, and no default is given
  class KeyError < ::KeyError
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def message
      "Enviroment Variable #{key} was missing, and no default was provided."
    end
  end

  # Exception raised in production if key is not present in ENV
  class ProductionKeyError < KeyError
    def message
      "Environment Variable #{key} is required."
    end
  end

  class Config
    extend Forwardable
    extend Dry::Core::Extensions

    register_extension(:heroku) do
      require "env_config/heroku"
      prepend Heroku
    end

    register_extension(:rails) do
      require "env_config/rails"
      prepend Rails
    end

    delegate %i[key?] => :@env

    def initialize(env = ENV, **)
      @env = env
    end

    # Like Hash#fetch. Returns the value from the env, or the default if no value is present in ENV.
    def fetch(name, *, &)
      @env.fetch(name, *, &)
    rescue ::KeyError
      raise KeyError, name
    end

    # Like #fetch, except it won't fallback to the default in production mode.
    def fetch!(name, *, &)
      if production?
        begin
          @env.fetch(name)
        rescue ::KeyError
          raise ProductionKeyError, name
        end
      else
        fetch(name, *, &)
      end
    end

    def production?
      fetch("RAILS_ENV", fetch("RACK_ENV", "development") ) == "production"
    end
  end
end
