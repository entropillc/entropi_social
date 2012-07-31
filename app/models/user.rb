class User < ActiveRecord::Base

  include EntropiSocial::Strategies::Facebook
  include EntropiSocial::Models::User
  
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :profile_attributes, 
                  :profile, :admin, :banned, :terms_accepted, :provider, :uid


  validates_presence_of :username, :email
  
  has_one :avatar, :class_name => "Photo", :as => :photoable
  
  has_one :profile, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :groups, :as => :groupable

  accepts_nested_attributes_for :profile

  def full_name
    profile.full_name
  end

  def admin?
    return self.admin
  end

  class << self
    
    def search(keywords)
      unless keywords.empty?
        keywords = keywords.collect { |word| "%"+ word + "%"}
        where{email.like_all(keywords)} 
      else
        all
      end
    end

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create(  provider:auth.provider,
                             uid:auth.uid,
                             email:auth.info.email,
                             password:Devise.friendly_token[0,20])
        if user
          profile = user.build_profile(:first_name => auth.info.first_name, :last_name => auth.info.last_name)
          profile.save!
        end
      end
      user
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
          user.profile = user.build_profile(  :first_name => data["first_name"], 
                                              :last_name => data["last_name"])
        end
      end
    end
    
  end
  
end
