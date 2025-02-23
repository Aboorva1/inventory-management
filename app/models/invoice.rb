class Invoice < ApplicationRecord
  has_many :products_to_invoice, dependent: :destroy
  has_many :products, through: :products_to_invoice
  accepts_nested_attributes_for :products_to_invoice

  before_save :calculate_total
  after_create :update_stock_levels
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
end
