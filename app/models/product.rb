class Product < ApplicationRecord
  has_many :products_to_invoice, dependent: :destroy
  has_many :invoices, through: :products_to_invoice
end