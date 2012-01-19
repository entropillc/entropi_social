class AssetUploader < CarrierWave::Uploader::Base

  # Include RMagick support:
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "/uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # the following declarations create different size images for the files that are uploaded to the site.
  version :thumb do
    process :resize_to_fill => [64, 64]
  end
  
  version :small do
     process :resize_to_fill => [150, 150]
  end 
  
  version :medium  do
    process :resize_to_fill => [300, 300] 
  end 
  
  version :large do 
    process :resize_to_fill => [600, 600]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
