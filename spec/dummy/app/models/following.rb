class Following < ActiveRecord::Base
  
  belongs_to :article
  belongs_to :reader
end
