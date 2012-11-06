require 'rails'

require 'acts_as_word_cloud/config'

module ActsAsWordCloud
  class Railtie < ::Rails::Railtie
    initializer 'acts_as_word_cloud' do |app|
      require 'acts_as_word_cloud/word_cloud'
      ActiveRecord::Base.send :include, ActsAsWordCloud::WordCloud
    end
  end
end
