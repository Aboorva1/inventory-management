class StockMailer < ApplicationMailer
  default from: "samplemail@gmail.com"

  def low_stock_alert(products)
    @products = products
    mail(
      to: "abookannan567@gmail.com",
      subject: "Low Stock Alert for Multiple Products"
    )
  end
end
