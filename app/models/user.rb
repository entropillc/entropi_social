class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :profile_attributes, :profile

  validates_presence_of :username, :email
  
  has_one :avatar, :class_name => "Photo", :as => :photoable
  
  has_one :profile, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :groups, :as => :groupable

  
  accepts_nested_attributes_for :profile


end
