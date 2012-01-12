class Photo < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true
  belongs_to :user
  has_many :comments
  
  mount_uploader :avatar, AssetUploader
end