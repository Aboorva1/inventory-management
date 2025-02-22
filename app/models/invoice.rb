class Invoice < ApplicationRecord
  has_many :products_to_invoice, dependent: :destroy
  has_many :products, through: :products_to_invoice
end
