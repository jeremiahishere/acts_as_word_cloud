class Reader < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [:username], :excluded_models => [], :skipped_attributes => [], :depth => 1
  
  has_many :followings
  has_many :articles, :through => :followings
  belongs_to :site
end
