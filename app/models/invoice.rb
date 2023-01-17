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

  #returns the total discount amount for all invoice items that meet the discount criteria. 
  def total_discount 
    invoice_items.select('invoice_items.*, sum(invoice_items.unit_price * invoice_items.quantity * (discounts.percentage)/100) AS calculated_discount')
                 .joins(:discounts)
                 .where('invoice_items.quantity >= discounts.threshold')
                 .group(:id)
                 .sum { |invoice_item| invoice_item.calculated_discount }
  end

  def total_discounted_revenue
    total_revenue - total_discount
  end
end
