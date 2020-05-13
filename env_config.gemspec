# frozen_string_literal: true

require_relative "lib/env_config/version"

Gem::Specification.new do |spec|
  spec.name          = "env_config"
  spec.version       = EnvConfig::VERSION
  spec.authors       = ["Paul Sadauskas"]
  spec.email         = ["paul@sadauskas.com"]

  spec.summary       = "Safely use Environment Variables locally and in production"
  spec.description   = <<~TXT
    Its easy to add an environment variable to your app and then forget to set
    it in production, and your whole app goes down. EnvConfig will help catch
    those errors early, before the deploy takes down your site.
  TXT
  spec.homepage      = "https://github.com/paul/env_config"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/paul/env_config"
  spec.metadata["changelog_uri"] = "https://github.com/paul/env_config/blob/master/Changelog.mkd"

  spec.files         = Dir["lib/**/*"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = Dir["README.mkd", "CHANGELOG.mkd", "LICENSE.txt"]
  spec.rdoc_options += [
    "--title", "EnvConfig - Convenience helpers for your ENV",
    "--main", "README.md",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]

  spec.add_dependency "dry-core", "~> 0.1"

  spec.add_development_dependency "rspec", "~> 3.8"
end
