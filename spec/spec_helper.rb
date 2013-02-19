$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

# require 'rails/test_help'
require 'rspec/rails'
require 'acts_as_word_cloud'
require 'database_cleaner'

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end 

  config.before(:each) do
    DatabaseCleaner.start
  end 

  config.after(:each) do
    DatabaseCleaner.clean
  end 
    
end
