class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, #:invitable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :username, :birth_date, :email, :password, :password_confirmation, :remember_me

  validates_presence_of :username, :email
  
  has_one :avatar, :class_name => "Photo", :as => :photoable
  
  has_one :profile, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :groups, :as => :groupable

  
  accepts_nested_attributes_for :profile


end
