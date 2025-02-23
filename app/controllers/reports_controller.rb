class ReportsController < ApplicationController
  def index
    @start_date = Date.today - 30.days
    @end_date = Date.today
    @total_sales = nil
    @most_sold_products = []
  end

  def generate
    start_date = params[:start_date].presence || Date.today - 30.days
    end_date = params[:end_date].presence || Date.today

    @start_date = Date.parse(start_date.to_s)
    @end_date = Date.parse(end_date.to_s)

    @total_sales = Invoice.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day).sum(:total)
    @most_sold_products = ProductsToInvoice.joins(:product, :invoice).where(invoices: { created_at: @start_date.beginning_of_day..@end_date.end_of_day })
      .group("products.name")
      .order("SUM(products_to_invoices.quantity) DESC")
      .sum("products_to_invoices.quantity")

    render :index
  end
end
