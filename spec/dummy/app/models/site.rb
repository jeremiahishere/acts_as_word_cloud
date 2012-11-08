class Site < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [:domain], :excluded_models => [], :depth => 1
  
  has_many :articles
  has_many :authors
  has_many :readers
  belongs_to :publisher
end
