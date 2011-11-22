class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :username, :birth_date, :email, :password, :password_confirmation, :remember_me

  validates_presence_of :username, :email, :first_name, :last_name, :birth_date
  
  has_one :avatar, :class_name => "Photo", :as => :photoable
  
  has_one :profile
  has_many :memberships
  has_many :groups, :as => :groupable
  
  
  #TODO: These need abstracted out in to application specific code outside the Entropi Social gem.
  #has_many :entries
  #has_many :comments
  #has_many :photos
  
  #accepts_nested_attributes_for :profile

  def full_name
    first_name + " "  + last_name
  end

  def invitation_limit
    self[:available_invitations] ? self[:available_invitations] : 0
  end

  # Return true if this user has invitations left to send
  def has_invitations_left?
    if self[:available_invitations]
      if available_invitations
        return available_invitations > 0
      else
        return false
      end
    else
      return true
    end
  end

  protected
    def decrement_invitation_limit!
      self.update_attribute(:invitation_limit, invitation_limit - 1)
    end
end
