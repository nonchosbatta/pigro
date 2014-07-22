ENV['RACK_ENV'] = 'test'
require './pigro'

require 'rspec'
require 'rack/test'
require 'rspec/expectations'
require 'rspec/collection_matchers'
require 'json'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
