class Author < ActiveRecord::Base
  acts_as_word_cloud
  
  has_many :articles
  belongs_to :publisher

  def to_s
    "Author #{id}"
  end
end
