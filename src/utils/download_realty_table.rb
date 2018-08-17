require_relative 'download'

module Utils
  # Download files containing data of offers in each estate
  class DownloadRealtyTable
    include Download

    def initialize(estate, output_folder)
      @url = "http://www1.caixa.gov.br/listaweb/Lista_imoveis_#{estate}.zip"
      @filename = File.join(output_folder, "#{estate.downcase}.7z")
    end

    def start
      download(@url, @filename)
    end
  end
end
