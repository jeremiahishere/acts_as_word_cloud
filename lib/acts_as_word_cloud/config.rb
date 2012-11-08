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
    config_accessor :min_depth
    config_accessor :no_mixin_fields

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call() : config.param_name
    end
  end

  # setup default options
  # this should match the generator config that goes in the initializer file
  configure do |config|
  end
end

