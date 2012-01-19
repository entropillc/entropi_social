class RemoveColumnsFromPhotos < ActiveRecord::Migration
  def up
    remove_column :photos, :photo_file_name
    remove_column :photos, :photo_content_type
    remove_column :photos, :photo_file_size
  end

  def down
  end
end
