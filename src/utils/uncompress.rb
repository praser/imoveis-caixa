module Utils
  # Uncompress compacted files
  class Uncompress
    def self.extract_all(path)
      output = IO.popen "7za -y x '#{File.join(path, '*.7z')}' -o#{path}"
      output.readlines.empty? ? false : true
    end
  end
end
