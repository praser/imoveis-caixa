require 'httparty'

module Utils
  # Download files from a URL
  module Download
    def download(url, output_file)
      File.open(output_file, 'w') do |file|
        HTTParty.get url, stream_body: true do |fragment|
          file.write fragment
        end
      end
    end
  end
end
