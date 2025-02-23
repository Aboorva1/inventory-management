class Invoice < ApplicationRecord
  has_many :products_to_invoice, dependent: :destroy
  has_many :products, through: :products_to_invoice
  accepts_nested_attributes_for :products_to_invoice

  before_save :calculate_total
  after_create :update_stock_levels
  after_commit :check_stock_after_invoice, on: [:create, :update]

  enum status: { pending: 0, paid: 1, cancelled: 2 }

  private

  def calculate_total
    self.total = products_to_invoice.sum { |item| item.product.price * item.quantity } - discount.to_f
  end

  def update_stock_levels
    products_to_invoice.each do |item|
      item.product.update(quantity: item.product.quantity - item.quantity)
    end
  end

  def check_stock_after_invoice
    low_stock_products = products.select { |product| product.quantity < 3 }

    if low_stock_products.any?
      StockMailer.low_stock_alert(low_stock_products).deliver_later
    end
  end
end
