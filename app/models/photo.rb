class Photo < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true
  belongs_to :user
  has_many :comments
  
  has_attached_file :photo, :styles => { :small => '50x50#', :thumbnail => "150x150>", :profile => '200x200!', :large => '500x500' }
  
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => ["image/jpeg", "image/gif", "image/png"]
end
