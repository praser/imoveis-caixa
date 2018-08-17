module Realty
  # Data formatter for Realty properties
  class Formatter
    def trim(text)
      text.strip.squeeze(' ').delete("\n")
    end

    def bidding_item(text)
      trim(text).gsub('Número do item: ', '').to_i
    end

    def bidding_notice(element)
      return element if element.nil?

      text = element.attr('onclick')
      path = trim(text).gsub("javascript:ExibeDoc('", '').gsub("')", '')
      "http://www1.caixa.gov.br#{path}"
    end

    def price(text)
      float trim(text).gsub('Valor de venda: R$ ', '')
    end

    def evaluation_price(text)
      float trim(text).gsub('Valor de avaliação: R$ ', '')
    end

    def float(text)
      text.delete('.').tr(',', '.').to_f
    end

    def photo(text)
      text.strip.casecmp 'ver foto'
    end

    def id(text)
      text.strip.split('=').last
    end

    def type_of_sale(text)
      return 'Venda Online' if text == ''
      trim text.gsub('Edital: ', '')
    end

    def url(element)
      element.attr('href').strip unless element.nil?
    end
  end
end
