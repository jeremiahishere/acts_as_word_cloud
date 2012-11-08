require 'rails/generators'
require 'rails/generators/migration'
require 'active_record'
require 'rails/generators/active_record'

module ActsAsWordCloud
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc <<DESC
Description:
  Copies over migrations and config for the normalizer.
DESC

      def copy_config_file
        copy_file "config.rb", "config/initializers/acts_as_word_cloud.rb"
      end
    end
  end
end
