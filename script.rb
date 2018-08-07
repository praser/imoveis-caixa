require 'httparty'
require 'nokogiri'
require 'aws-sdk-s3'

# Download files from server
ufs = %w(AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO)
ufs.each do |uf|
  filename = "Lista_imoveis_#{uf}"
  url = "http://www1.caixa.gov.br/listaweb/#{filename}.zip"
  p "Downloading #{filename}"
  
  File.open("./files/#{filename}.7z", "w") do |file|
    HTTParty.get(url, stream_body: true) do |fragment|
      file.write(fragment)
    end
  end
end

# Uncompress files
system "7za -y x './files/*.7z' -o./files"

# Parse files
data = { realty: [] }
files = Dir['./files/*.htm']

files.each do |file|
  p "Processing #{file}"
  doc = File.open(file) { |f| Nokogiri::HTML(f) }
  doc.css("html > body > table > tr:nth-child(n+2)").each do |line|
    data[:realty].push({
      address: line.at_css("td:nth-child(2) > p > span").text.strip.squeeze(" ").gsub("\n", ''),
      neighborhood: line.at_css("td:nth-child(3) > p > span").text.strip.squeeze(" ").gsub("\n", ''),
      city: line.at_css("td:nth-child(7) > p > span").text.strip.squeeze(" ").gsub("\n", ''),
      state: line.at_css("td:nth-child(8) > p").text.strip.squeeze(" ").gsub("\n", ''),
      description: line.at_css("td:nth-child(4) > p > span").text.strip.squeeze(" ").gsub("\n", ''),
      has_photo: line.at_css("td:nth-child(6) > p > u > span > a").text.strip.downcase === "ver foto",
      price: line.at_css("td:nth-child(5) > p > span").text.strip.squeeze(" ").gsub("\n", ''),
      url: line.at_css("td:nth-child(1) > p > u > span > a").attr('href')
    })
  end
end

# Write to output
filename = "#{Time.now.strftime '%Y-%m-%dT%H:%M:%S'}-data.json"
File.open("./files/#{filename}", 'w') do |file|
  file.write(data.to_json)
end

# Clear directory
system 'rm -rf ./files/*.7z'
system 'rm -rf ./files/*.htm'

# Upload json to S3
s3 = Aws::S3::Resource.new(region:'us-east-2')
obj = s3.bucket('imoveis-caixa').object(filename)
obj.upload_file("./files/#{filename}")
