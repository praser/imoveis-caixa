require_relative 'src/download_files'
require_relative 'src/parse_files'
require 'getoptlong'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--log', '-l', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--output', '-o', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--uf', GetoptLong::REQUIRED_ARGUMENT  ]
)

log = nil
output = nil
uf = nil

opts.each do |opt, arg|
  case opt
  when '--help'
    puts <<-EOF
crawler [option] ...
    
-h, --help: Show help
-l [path], --log [path]: Absolute path of the log folder
-o [path], --output [path]: Absolute path of the output folder
--uf[uf]: Abbreviation with tho letter of the estate to be crawled
    EOF
  when '--log'
    log = File.expand_path arg
  when '--output'
    output = File.expand_path arg
  when '--uf'
    uf = [arg]
  end
end

downloads = DownloadFiles.new uf
downloads.empty
downloads.download
downloads.uncompress

data = ParseFiles.new output, log
data.parse 
data.to_file
data.empty
