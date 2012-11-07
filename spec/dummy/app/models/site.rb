class Site < ActiveRecord::Base
  has_many :articles
  has_many :authors
  belongs_to :publisher
end
