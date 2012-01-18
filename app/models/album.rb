class Album < ActiveRecord::Base
  
  has_many :photos, :as => :photoable
  
  belongs_to :profile
  
  validates_presence_of :name, :profile_id
  
  scope :readable_by, lambda { |profile| where(:profile_id => profile.id)}
  
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
  
  def self.for(profile)
    Album.readable_by(profile)
  end
  
end
