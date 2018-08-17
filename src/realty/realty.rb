module Realty
  # A Real State representation
  class Realty
    attr_accessor :address, :neighborhood, :city, :estate, :description,
                  :photo, :price, :url, :id, :evaluation_price, :situation,
                  :type_of_sale, :bidding_notice, :bidding_item

    def to_hash
      {
        address: @address, neighborhood: @neighborhood, city: @city,
        estate: @estate, description: @description, photo: @photo,
        price: @price, url: @url, id: @id, evaluation_price: @evaluation_price,
        situation: @situation, type_of_sale: @type_of_sale,
        bidding_notice: @bidding_notice, bidding_item: @bidding_item
      }
    end
  end
end
