# frozen_string_literal: true

require "active_support/string_inquirer"

class EnvConfig
  module Rails
    extend Forwardable

    attr_reader :app_env

    def initialize(env = ENV, app_env: ::Rails.env)
      super
      @app_env = app_env
    end

    # Works like #fetch, but converts "truthy" or "falsy" values to a Boolean
    # "t", "true", "1" => true
    # "f", "false", "0", "" => false
    def fetch?(name, *, &)
      ActiveModel::Type::Boolean.new.cast(fetch(name, *, &))
    end

    delegate %i[local?] => :@app_env

    # When using EnvConfig.fetch!, anything not dev or test is considered "production".
    def production? = !local?
  end
end
