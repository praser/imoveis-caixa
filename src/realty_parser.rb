require 'nokogiri'

class RealtyParser
  def initialize(path)
    @data = { realty: [] }
    @path = path
    @files = Dir[File.join(@path, '*.htm')]
  end

  def parse
    @files.each do |file|
      parse_file(file)
    end

    write_to_file(@data)
  end

  private

  attr :data, :files, :path

  def parse_file(file)
    doc = File.open(file) { |f| Nokogiri::HTML(f) }
    doc.css("html > body > table > tr:nth-child(n+2)").each do |line|
      @data[:realty].push set_realty(
        address(line),
        neighborhood(line),
        city(line),
        state(line),
        description(line),
        has_photo(line),
        price(line),
        url(line)
      )
    end
    
    return @data
  end

  def trim(text)
    text.strip.squeeze(" ").gsub("\n", '')
  end

  def address(line)
    trim line.at_css("td:nth-child(2) > p > span").text
  end

  def neighborhood(line)
    trim line.at_css("td:nth-child(3) > p > span").text
  end

  def city(line)
    trim line.at_css("td:nth-child(7) > p > span").text
  end

  def state(line)
    trim line.at_css("td:nth-child(8) > p").text
  end

  def description(line)
    trim line.at_css("td:nth-child(4) > p > span").text
  end

  def has_photo(line)
    line.at_css("td:nth-child(6) > p > u > span > a").text.strip.downcase === "ver foto"
  end

  def price(line)
    (trim line.at_css("td:nth-child(5) > p > span").text.gsub('.', '').gsub(',', '.')).to_f
  end

  def url(line)
    line.at_css("td:nth-child(1) > p > u > span > a").attr('href').strip
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
