require 'carrierwave'

CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
    :region                => 'us-east-1'
  }
  config.storage = :fog 
  config.fog_directory = ENV['S3_BUCKET']
  config.cache_dir = '../tmp'
end

class Uploader < CarrierWave::Uploader::Base
  def store_dir
    'predictions'
  end
end
