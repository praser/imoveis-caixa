require 'httparty'

class Download
  def self.files
    ufs = %w(AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO)
    ufs.each do |uf|
      filename = "Lista_imoveis_#{uf}.zip"
      url = "http://www1.caixa.gov.br/listaweb/#{filename}"

      File.open("./downloads/#{filename}", "w") do |file|
        response = HTTParty.get(url, stream_body: true) do |fragment|
          file.write(fragment)
        end
      end      
    end
  end
end

Download.files