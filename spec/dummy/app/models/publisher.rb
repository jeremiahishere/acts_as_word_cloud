class Publisher < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [:name], :excluded_models => [], :skipped_attributes => [], :depth => 1
  
  has_one :site
  has_many :articles
  has_many :authors
end
