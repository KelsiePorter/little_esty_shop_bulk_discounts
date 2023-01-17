class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :discounts, through: :merchants

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  #returns the qualifying discount with the higest discount percentage
  #to be used on the qualifying invoice item(s). 
  #looks at all the merchants discounts and pick the ones where
  #the invoice item quantity is greater than or equal to the threshold
  def qualifying_discount
    discounts.where("threshold <= ?", quantity)
             .order(percentage: :desc)
             .limit(1)
             .first
  end
end
