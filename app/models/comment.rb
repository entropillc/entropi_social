class Comment < ActiveRecord::Base
  include EntropiSocial::Commentable::Finders

  belongs_to :commentable, :polymorphic => true
  
  # NOTE: Comments belong to a profile
  belongs_to :profile
  
  def as_json(options={})
    hash = super.as_json
    # add profile to json
    hash["profile"] = self.profile
    return hash    
  end
end