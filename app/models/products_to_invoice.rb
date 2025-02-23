class ProductsToInvoice < ApplicationRecord
  belongs_to :invoice
  belongs_to :product

  before_create :set_product_price

  private

  def set_product_price
    self.price = product.price
  end

end
