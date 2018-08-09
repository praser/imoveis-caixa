require 'nokogiri'

class RealtyParser
  def initialize(path)
    @data = { realty: [] }
    @path = path
    @files = Dir[File.join(@path, '*.htm')]
  end

  def parse
    @files.each do |file|
      @data[:realty].push parse_file(file)
    end

    write_to_file(@data)
  end

  private

  attr :data, :files, :path

  def parse_file(file)
    obj = nil
    doc = File.open(file) { |f| Nokogiri::HTML(f) }
    doc.css("html > body > table > tr:nth-child(n+2)").each do |line|
      address = trim line.at_css("td:nth-child(2) > p > span").text
      neighborhood = trim line.at_css("td:nth-child(3) > p > span").text
      city = trim line.at_css("td:nth-child(7) > p > span").text
      state = trim line.at_css("td:nth-child(8) > p").text
      description = trim line.at_css("td:nth-child(4) > p > span").text
      has_photo = line.at_css("td:nth-child(6) > p > u > span > a").text.strip.downcase === "ver foto"
      price = (trim line.at_css("td:nth-child(5) > p > span").text.gsub('.', '').gsub(',', '.')).to_f
      url = line.at_css("td:nth-child(1) > p > u > span > a").attr('href').strip

      obj = set_realty(address, neighborhood, city, state, description, has_photo, price, url)
    end
    
    return obj
  end

  def trim(text)
    text.strip.squeeze(" ").gsub("\n", '')
  end

  def set_realty(address, neighborhood, city, state, description, has_photo, price, url)
    return {
      address: address,
      neighborhood: neighborhood,
      city: city,
      state: state,
      description: description,
      has_photo: has_photo,
      price: price,
      url: url
    }
  end

  def write_to_file(data)
    filename = "#{Time.now.strftime '%Y-%m-%dT%H:%M:%S'}-data.json"
    File.open(File.join(@path, filename), 'w') do |file|
      file.write data.to_json
    end

    filename
  end
end
