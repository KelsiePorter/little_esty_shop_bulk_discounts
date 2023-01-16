class AddDiscountedUnitPriceToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :discounted_unit_price, :float
  end
end
