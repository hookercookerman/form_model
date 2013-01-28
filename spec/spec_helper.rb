require "rubygems"
require "bundler/setup"

unless ENV["TRAVIS"]
  require 'simplecov'
  SimpleCov.start do
    add_group "lib", "lib"
    add_group "spec", "spec"
  end
end

require "pry"
require "form_model"

Dir.glob(File.expand_path('../../spec/support/virtus/**/*.rb', __FILE__)) do |file|
  require file
end

Dir.glob(File.expand_path('../../spec/support/mappers/**/*.rb', __FILE__)) do |file|
  require file
end

Dir.glob(File.expand_path('../../spec/support/**/*.rb', __FILE__)) do |file|
  require file
end

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
