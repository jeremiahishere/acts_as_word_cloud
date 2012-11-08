$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require File.expand_path("../dummy/features/support/blueprints", __FILE__) 
require File.expand_path("../dummy/lib/model_methods_helper", __FILE__)

require 'rspec'
require 'acts_as_word_cloud'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
  config.mock_with :rspec
    
end
