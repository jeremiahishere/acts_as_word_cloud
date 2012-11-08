class Publisher < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [], :excluded_models => [], :depth => 1
  
  has_one :site
  has_many :articles
  has_many :authors
end
