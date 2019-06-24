# frozen_string_literal: true

require 'factory_bot'
require 'pp'
require 'rspec'
require 'simplecov'
require_relative '../lib/obscured-timeline'

SimpleCov.start do
  add_filter '/spec/'
end

Mongoid.load!(File.join(File.dirname(__FILE__), '/config/mongoid.yml'), 'spec')
Mongo::Logger.logger.level = Logger::ERROR

RSpec.configure do |c|
  c.include FactoryBot::Syntax::Methods
  c.filter_run_excluding integration: true
  c.filter_run_excluding broken: true

  c.before(:suite) do
    FactoryBot.find_definitions
    Mongoid.purge!

    Mongoid::Search.setup do |cfg|
      cfg.strip_symbols = /[\"]/
      cfg.strip_accents = //
    end
  end

  c.before(:each) do
    Mongoid.purge!
  end

  c.after(:suite) do
    Mongoid.purge!
  end
end