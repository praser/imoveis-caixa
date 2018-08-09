require_relative 'src/download'
require_relative 'src/realty_parser'
require_relative 'src/file_manager'
require_relative 'src/storage'

path = File.join(__dir__, 'files')
fm = FileManager.new(path)
fm.clear_folder
Download.new(path).start
system "7za -y x '#{File.join(path, '*.7z')}' -o#{path}"
fm.clear_folder_by_extname('.7z')
filename = RealtyParser.new(path).parse # Parse files
fm.clear_folder_by_extname('.htm')
Storage.upload(File.join(path, filename))
fm.clear_folder_by_extname('.json')
