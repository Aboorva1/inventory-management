class ProductsToInvoice < ApplicationRecord
  belongs_to :invoice
  belongs_to :product
end
