class AssetUploader < CarrierWave::Uploader::Base

  # Include RMagick support:
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{Rails.env}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create Thumb Image
  version :thumb do
    process :resize_to_fill => [50, 50]
  end
  
  version :thumbnail do
     process :resize_to_fill => [150, 150]
  end 
  
  version :profile  do
    process :resize_to_fill => [200, 200] 
  end 
  
  version :large do 
    process :resize_to_fill => [500, 500]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
