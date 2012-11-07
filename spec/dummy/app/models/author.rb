class Author < ActiveRecord::Base
  has_many :articles
  has_many :publisher
  belongs_to :site
end

