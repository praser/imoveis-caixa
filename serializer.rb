require 'nokogiri'

properties = []

doc = File.open('./downloads/lista_imoveis_DF.htm') { |f| Nokogiri::HTML(f) }
doc.css("html > body > table > tr:nth-child(n+2)").each do |line|
  properties.push({
    address: line.at_css("td:nth-child(2) > p > span").text.strip,
    neighborhood: line.at_css("td:nth-child(3) > p > span").text.strip,
    description: line.at_css("td:nth-child(4) > p > span").text.strip,
    price: line.at_css("td:nth-child(5) > p > span").text.strip,
    has_photo: line.at_css("td:nth-child(6) > p > u > span > a").text.strip.downcase === "ver foto",
    city: line.at_css("td:nth-child(7) > p > span").text.strip,
    state: line.at_css("td:nth-child(8) > p").text.strip
  })
end

p properties.last[:description].squeeze(" ").gsub("\n", '')