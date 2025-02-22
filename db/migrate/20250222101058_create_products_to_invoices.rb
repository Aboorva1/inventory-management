class CreateProductsToInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :products_to_invoices do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
