class ArticleReader < ActiveRecord::Base
  acts_as_word_cloud :included_methods => [:name]
  
  belongs_to :article
  belongs_to :reader

  def name
    "ArticleReader #{id}"
  end
end
