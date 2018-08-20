require 'json'
require_relative 'amazon_s3'

module Utils
  # Output data hash to JSON files
  class Output
    attr_accessor :folder, :filename

    def initialize(folder = nil, filename = nil)
      @filename = filename || 'output.json'
      @folder = folder || File.join(__dir__, '..', '..', 'files')
    end

    def write(hash_content)
      File.open(File.join(@folder, @filename), 'w') do |f|
        f.write JSON.pretty_generate hash_content
      end
    end
  end
end
