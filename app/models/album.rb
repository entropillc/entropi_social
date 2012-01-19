class Album < ActiveRecord::Base
  acts_as_authorizable
  
  has_many :photos, :as => :photoable
  
  validates_presence_of :name, :profile_id
  
  def photo_count
    self.photos.size
  end
  
  def as_json(options={})
    {
      :id => self.id,
      :name => self.name,
      :description => self.description,
      :count => self.photo_count
    }
  end
  
 
end
