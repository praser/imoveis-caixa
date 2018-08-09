require 'aws-sdk-s3'

class Storage
  BUCKET = 'imoveis-caixa'

  def self.upload(file_path)
    s3 = Aws::S3::Resource.new(region:'us-east-2')
    obj = s3.bucket(BUCKET).object(File.basename(file_path))
    obj.upload_file(file_path)
  end
end