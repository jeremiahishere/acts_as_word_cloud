# this file was stolen from kaminari
require 'active_support/configurable'

module ActsAsWordCloud

  # create new configs by passing a block with the config assignment
  def self.configure(&block)
    yield @config ||= ActsAsWordCloud::Configuration.new
  end

  def self.config
    @config
  end

  # setup config data
  class Configuration
    include ActiveSupport::Configurable
    # default recursion depth when looking at data in associations
    config_accessor :default_search_depth
    # List of name methods to try on associations
    config_accessor :object_name_methods

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call() : config.param_name
    end
  end

  # setup default options
  # this should match the generator config that goes in the initializer file
  configure do |config|
    config.default_search_depth = 1
    config.object_name_methods = [:name, :title, :label, :to_s]
  end
end

