class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  #returns the total revenue without any discounts
  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  #returns the total revenue with discounts applied. If no discount
  #is applied, the unit_price is applied and used
  #This method calls on apply_applicable_discount! in invoice_item.rb
  def total_discounted_revenue
    invoice_items.each {|invoice_item| invoice_item.apply_applicable_discount!}
    invoice_items.sum("discounted_unit_price * quantity")
  end
end
