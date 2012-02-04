class AssetPhoto < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true
  belongs_to :photo
end