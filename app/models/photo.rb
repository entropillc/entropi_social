class Photo < ActiveRecord::Base
  acts_as_commentable
  acts_as_authorizable
  
  belongs_to :photoable, :polymorphic => true
  
  mount_uploader :asset, AssetUploader
  
  def as_json(options={})
    hash = {
      :id => self.id,
      :created_at => self.created_at,
      :thumb => asset.thumb.url,
      :small => asset.small.url,
      :medium => asset.medium.url, 
      :large => asset.large.url,
      :profile => self.profile,
      :comments => self.comments
    }
  end
end