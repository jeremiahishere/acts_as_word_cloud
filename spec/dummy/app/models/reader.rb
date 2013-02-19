class Reader < ActiveRecord::Base
  acts_as_word_cloud
  
  has_many :article_readers
  has_many :articles, :through => :article_readers

  def to_s
    "Reader #{id}"
  end
end
