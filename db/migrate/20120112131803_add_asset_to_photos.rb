class AddAssetToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :asset, :string
  end
end
