require 'aws-sdk-s3'

module Utils
  # Save files to Amazon S3
  class AmazonS3
    def self.upload(buket, file_path)
      if !ENV['AWS_ACCESS_KEY_ID'].nil? &&
         !ENV['AWS_ACCESS_KEY_ID'].nil? &&
         !ENV['AWS_S3_BUKET_REGION'].nil?
        s3 = Aws::S3::Resource.new(region: ENV['AWS_S3_BUKET_REGION'])
        obj = s3.bucket(buket).object(File.basename(file_path))
        obj.upload_file(file_path)
      end
    end
  end
end
