class Article < ActiveRecord::Base
  acts_as_word_cloud :included_methods => [:truncated_title], :excluded_methods => [:genre], :excluded_models => [ArticleReader, Reader], :depth => 2, :object_name_method => :title
 
  belongs_to :author
  has_many :article_readers
  has_many :readers, :through => :article_readers

  def truncated_title
    title[0..5] if title
  end
end
