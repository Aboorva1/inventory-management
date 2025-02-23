class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[edit update destroy mark_as_paid]

  def index
    @invoices = Invoice.order("created_at DESC")
  end

  def show
    @invoice = Invoice.includes(products_to_invoice: :product).find(params[:id])
  end

  def new
    @invoice = Invoice.new
    @products = Product.where("quantity >= ?", 3)
  end

  def edit
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.status ||= :pending

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_path, notice: "Invoice was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: "Invoice was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_paid
    @invoice.update(status: "paid")
    redirect_to invoices_path, notice: "Invoice marked as paid."
  end
  
  def cancel
    @invoice = Invoice.includes(products_to_invoice: :product).find(params[:id])
    @invoice.update(status: "cancelled")
    @invoice.products_to_invoice.each do |item|
      item.product.update(quantity: item.product.quantity + item.quantity)
    end
    redirect_to invoices_path, notice: "Invoice cancelled."
  end  
  

  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to invoices_path, status: :see_other, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def invoice_params
      params.require(:invoice).permit(:customer_name, :customer_contact, :discount, :status,
      products_to_invoice_attributes: [:product_id, :quantity])
    end
end
