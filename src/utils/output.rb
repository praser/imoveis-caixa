require 'json'
module Utils
  # Output data hash to JSON files
  class Output
    attr_accessor :folder

    def initialize(folder = nil)
      @folder = folder || File.join(__dir__, '..', '..', 'files')
    end

    def to_json_file(filename, hash_content)
      file = File.open(File.join(@folder, "#{filename}.json"), 'w')
      file.write JSON.pretty_generate hash_content
    end
  end
end
