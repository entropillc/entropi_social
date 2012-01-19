class Group < ActiveRecord::Base
  
  has_many :memberships
  belongs_to :groupable, :polymorphic => true
  belongs_to :user
  
end
