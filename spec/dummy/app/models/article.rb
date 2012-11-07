class Article < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [], :excluded_methods => [], :depth => 1
 
  has_one :author
  has_one :publisher
  has_many :readers
  belongs_to :site
end
