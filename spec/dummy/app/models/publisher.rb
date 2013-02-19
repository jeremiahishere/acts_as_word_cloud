class Publisher < ActiveRecord::Base
  has_many :authors
  has_many :articles, :through => :authors

  def to_s
    "Publisher #{id}"
  end
end
