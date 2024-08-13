# frozen_string_literal: true

require "spec_helper"

RSpec.describe EnvConfig::Config do
  subject(:env_config) { described_class.new(env) }

  let(:env) { { "HELLO" => "world!" } }

  describe "#fetch" do
    it "uses the value from env when present in env" do
      expect(env_config.fetch("HELLO")).to eq "world!"
    end

    it "uses the fallback value when not present in env" do
      expect(env_config.fetch("NOT_SET", "default")).to eq "default"
    end

    it "raises an error when not present in env and no fallback is set" do
      expect{ env_config.fetch("NOT_SET") }.to raise_error EnvConfig::KeyError
    end
  end

  describe "#fetch!" do
    it "uses the value from env when present in env" do
      expect(env_config.fetch!("HELLO")).to eq "world!"
    end

    it "uses the fallback value when not present in env" do
      expect(env_config.fetch!("NOT_SET", "default")).to eq "default"
    end

    it "raises an error when not present in env and no fallback is set" do
      expect{ env_config.fetch!("NOT_SET") }.to raise_error EnvConfig::KeyError
    end

    context "when in production mode" do
      let(:env) { { "HELLO" => "world!", "RAILS_ENV" => "production" } }

      it "raises an error instead of using the fallback value" do
        expect{
          env_config.fetch!("NOT_SET", "default")
        }.to raise_error EnvConfig::ProductionKeyError
      end
    end
  end
end
