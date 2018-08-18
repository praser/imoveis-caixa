module Utils
  # Manages a file directory
  class FileManager
    EXCEPT = ['.', '..', '.keep'].freeze

    def initialize(path)
      @path = path
    end

    def clear_folder
      Dir.foreach(@path) do |file|
        File.delete(File.join(@path, file)) unless EXCEPT.include? file
      end
    end
  end
end
