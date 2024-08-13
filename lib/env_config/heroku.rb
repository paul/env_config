# frozen_string_literal: true

require "json"

class EnvConfig
  module Heroku
    def fetch!(name, *args, &)
      check_app_json(name)
      super
    end

    def app_name
      @app_name ||= @env.fetch("HEROKU_APP_NAME") { `whoami`.chomp }
    end

    def heroku?
      return @heroku if defined?(@heroku)

      @heroku = @env.key?("HEROKU_APP_NAME")
    end

    def dyno
      @dyno ||= ActiveSupport::StringInquirer.new(ENV.fetch("DYNO", "dev").split(".").first)
    end

    def pr_number
      fetch("HEROKU_PR_NUMBER")
    end

    private

    def app_json_env
      @app_json ||= JSON.parse Rails.root.join("app.json").read
      @app_json["env"] || {}
    end

    def check_app_json(key)
      return unless production?

      if app_json_env[key.to_s].blank?
        warn "Environment Variable '#{name}' is not present in app.json"
      elsif app_json_env.dig(key.to_s, "required") != true
        warn "Environment Variable '#{name}' is present in app.json, but is not set to required: true"
      end
    end
  end
end
