require 'httparty'

class Download
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def start
    ESTATES.each do |estate|
      download(estate)
    end
  end

  private

  attr :filename, :url
  attr_writer :path
  ESTATES = %w(AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO)

  def create_url(estate)
    "http://www1.caixa.gov.br/listaweb/Lista_imoveis_#{estate}.zip"
  end

  def download(estate='AC')
    File.open(File.join(@path, "Lista_imoveis_#{estate}.7z"), "w") do |file|
      HTTParty.get create_url(estate), stream_body: true do |fragment|
        file.write fragment
      end
    end
  end
end
