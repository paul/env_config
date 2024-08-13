# frozen_string_literal: true

require "delegate"

require_relative "env_config/config"

# EnvConfig is a simple wrapper around Ruby's `ENV` hash. It only supports
# the `.fetch` method, which looks for a key in ENV, falling back to a default
# if one is provided. See
# http://ruby-doc.org/core-2.2.0/Hash.html#method-i-fetch Additionally, it
# provides a `.fetch!` which will do the same, however it will not fall back to
# the default if Rails.env is "production". This is useful to provide a safe
# default for use in dev and testing, without needing to specifiy it in a .env
# file, however it will still blow up in production.
class EnvConfig
  class << self
    # Borrowed implementation of +delegate_missing_to+ from Rails'
    # ActiveSupport::Delegation
    def respond_to_missing?(name, include_private = false)
      # It may look like an oversight, but we deliberately do not pass
      # +include_private+, because they do not get delegated.
      EnvConfig::Config.respond_to?(name) ||
        __instance.respond_to?(name) ||
        super
    end

    def method_missing(method, *args, &block)
      if EnvConfig::Config.respond_to?(method)
        EnvConfig::Config.public_send(method, *args, &block)
      elsif __instance.respond_to?(method)
        __instance.public_send(method, *args, &block)
      else
        super
      end
    end

    private

    def __instance
      @__instance ||= EnvConfig::Config.new(ENV)
    end
  end
end
