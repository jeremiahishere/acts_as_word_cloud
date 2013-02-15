class Article < ActiveRecord::Base
  acts_as_word_cloud :methods_to_use => [:title], :excluded_models => [], :skipped_attributes => [], :depth => 1
 
  belongs_to :author
  belongs_to :publisher
  belongs_to :site
  has_many :followings
  has_many :readers, :through => :followings
end
