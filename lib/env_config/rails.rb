# frozen_string_literal: true

require "active_support/string_inquirer"

class EnvConfig
  module Rails
    def initialize(env = ENV, app_env: Rails.env)
      super
      @app_env = app_Env
    end

    def fetch?(name, *, &)
      ActiveModel::Type::Boolean.new.cast(fetch(name, *, &))
    end

    delegate %i[development? test? production?] => :app_env
  end
end
