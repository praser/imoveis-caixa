require 'zip'

Zip::File.open('Lista_imoveis_RO.zip') do |zipfile|
  zipfile.each do |entry|
    # The 'next if...' code can go here, though I didn't use it
    unless File.exist?(entry.name)
      FileUtils::mkdir_p(File.dirname(entry.name))
      zipfile.extract(entry, entry.name) 
    end
  end
end