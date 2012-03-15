class User < ActiveRecord::Base
  
=begin
  devise :database_authenticatable, :registerable, #:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
=end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :profile_attributes, :profile

  validates_presence_of :username, :email
  
  has_one :avatar, :class_name => "Photo", :as => :photoable
  
  has_one :profile, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :groups, :as => :groupable

  accepts_nested_attributes_for :profile

=begin
  class << self
    
    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      if user = User.where(:email => data.email).first
        user
      else # Create a user with a stub password. 
        User.create!(:email => data.email, :password => Devise.friendly_token[0,20]) 
      end
    end
    
    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"]
        end
      end
    end
    
  end
=end
  
end
