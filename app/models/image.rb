class Image < ApplicationRecord
  belongs_to :user  
  mount_uploader :picture, PictureUploader
  has_one_attached :image
  
end
