class Comment < ActiveRecord::Base
  include EntropiSocial::ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true
  
  # NOTE: Comments belong to a profile
  belongs_to :profile
end