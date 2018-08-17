require_relative 'realty'
require_relative 'formatter'
require_relative '../utils/download'
require 'nokogiri'

module Realty
  # Class responsible for parsing captured values from html files
  # into a Realty instance
  class Parser
    include Utils::Download

    XPATH = {
      neighborhood: 'td:nth-child(3) > p > span',
      city: 'td:nth-child(7) > p > span',
      estate: 'td:nth-child(8) > p',
      description: 'td:nth-child(4) > p > span',
      photo: 'td:nth-child(6) > p > u > span > a',
      url: 'td:nth-child(1) > p > u > span > a',
      address: '//*[@id="enderecos"]/div/div[3]/ul/li/address',
      price: '//*[@id="dadosImovel"]/div/div[1]/h4',
      ev_price: '//*[@id="dadosImovel"]/div/div[1]/h4[2]',
      situation: '//*[@id="dadosImovel"]/div/div[1]/div[1]/p[1]/span[2]/strong',
      sale_type: '//*[@id="dadosImovel"]/div/div[2]/p[1]/span[1]',
      bidding_notice: 'a:contains("Baixar edital e anexos")',
      bidding: '//*[@id="dadosImovel"]/div/div[2]/p[1]/span[2]'
    }.freeze

    attr_accessor :realty

    def initialize(output_folder)
      @output_folder = output_folder
      @f = Formatter.new
      @realty = Realty.new
    end

    def main_data(main_data)
      @realty.neighborhood = @f.trim main_data.at_css(XPATH[:neighborhood]).text
      @realty.city = @f.trim main_data.at_css(XPATH[:city]).text
      @realty.estate = @f.trim main_data.at_css(XPATH[:estate]).text
      @realty.description = @f.trim main_data.at_css(XPATH[:description]).text
      @realty.photo = @f.photo main_data.at_css(XPATH[:photo]).text
      @realty.url = @f.url main_data.at_css(XPATH[:url])
      @realty.id = @f.id @realty.url
    end

    def additional_data
      download_aditional_data
      doc = Nokogiri::HTML(File.open(output_file))

      @realty.address = @f.trim doc.xpath(XPATH[:address]).text
      @realty.price = @f.price doc.xpath(XPATH[:price]).text
      @realty.evaluation_price = @f.evaluation_price doc.xpath(XPATH[:ev_price]).text
      @realty.situation = @f. trim doc.xpath(XPATH[:situation]).text
      @realty.type_of_sale = @f.type_of_sale doc.xpath(XPATH[:sale_type]).text
      @realty.bidding_notice = @f.bidding_notice doc.at(XPATH[:bidding_notice])
      @realty.bidding_item = @f.bidding_item doc.xpath(XPATH[:bidding]).text
    end

    private

    def output_file
      File.join(@output_folder, "#{@realty.id}.html")
    end

    def download_aditional_data
      download @realty.url, output_file
    end
  end
end
