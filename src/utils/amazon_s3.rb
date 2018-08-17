require 'aws-sdk-s3'

module Utils
  # Save files to Amazon S3
  class AmazonS3
    def self.upload(buket, file_path)
      s3 = Aws::S3::Resource.new(region: 'us-east-2')
      obj = s3.bucket(buket).object(File.basename(file_path))
      obj.upload_file(file_path)
    end
  end
end
