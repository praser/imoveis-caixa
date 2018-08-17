require_relative 'src/download_files'
require_relative 'src/parse_files'

downloads = DownloadFiles.new
downloads.empty
downloads.download
downloads.uncompress

data = ParseFiles.new
data.parse
data.to_file
data.empty
