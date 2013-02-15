class Author < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [:name], :excluded_models => [], :skipped_attributes => [], :depth => 1
  
  has_many :articles
  belongs_to :publisher
  belongs_to :site
end
