class Photo < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true
  belongs_to :user
  has_many :comments
  
  mount_uploader :asset, AssetUploader
  
  def as_json(options={})
    {
      :id => self.id, 
      :thumb => asset.thumb.url,
      :small => asset.small.url,
      :medium => asset.medium.url, 
      :large => asset.large.url,
      :created_at => self.created_at
    }
  end
end