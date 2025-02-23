class Product < ApplicationRecord
  has_many :products_to_invoice, dependent: :destroy
  has_many :invoices, through: :products_to_invoice
  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end
end