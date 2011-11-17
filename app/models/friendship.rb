class Friendship < ActiveRecord::Base
  has_one :user
  #has_and_belongs_to_many :groups
end
