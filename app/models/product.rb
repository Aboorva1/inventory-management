class Product < ApplicationRecord
  has_many :products_to_invoice, dependent: :destroy
  has_many :invoices, through: :products_to_invoice

  after_commit :check_low_stock, on: [:create, :update]

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def check_low_stock
    if quantity < 3
      StockMailer.low_stock_alert([self]).deliver_later
    end
  end
end