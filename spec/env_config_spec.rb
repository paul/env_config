# frozen_string_literal: true

require "spec_helper"

RSpec.describe EnvConfig do
  it "acts like a singleton" do
    ENV["HELLO"] = "World"

    expect(described_class.fetch("HELLO")).to eq("World")
  end

  # it "can be configured" do
  #   ENV["HEROKU_APP_NAME"] = "my-app-production"
  #
  #   expect { described_class.app_name }.to raise_error(NoMethodError)
  #
  #   described_class.load_extensions(:heroku)
  #
  #   expect(described_class.app_name).to eq "my-app-production"
  # end
  #
  it "can register its own extensions" do
    class EnvConfig
      class Config
        register_extension(:my_extension) do
          def my_helper
            true
          end
        end
      end
    end

    EnvConfig::Config.load_extensions(:my_extension)

    expect(EnvConfig::Config.new.my_helper).to be true
  end

  it "exposes extensions on the singleton" do
    class EnvConfig
      class Config
        register_extension(:my_extension) do
          def my_helper
            true
          end
        end
      end
    end

    EnvConfig::Config.load_extensions(:my_extension)

    expect(described_class.my_helper).to be true
  end
end
