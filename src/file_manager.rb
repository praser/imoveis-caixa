class FileManager
  EXCEPT = ['.', '..']

  def initialize(path)
    @path = path
  end

  def clear_folder()
    Dir.foreach(@path) do |file|
      File.delete(File.join(@path, file)) if !EXCEPT.include? file
    end
  end

  def clear_folder_by_extname(extname)
    Dir.foreach(@path) do |file|
      File.delete(File.join(@path, file)) if File.extname(file) == extname
    end
  end
end
