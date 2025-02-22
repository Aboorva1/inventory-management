class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :customer_name
      t.string :customer_contact
      t.decimal :total
      t.decimal :discount
      t.integer :status

      t.timestamps
    end
  end
end
