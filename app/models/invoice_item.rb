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

  #This updates the newly created discounted_unit_price attribute (column)
  #on the InvoiceItems table to be the return (float) of the 
  #discounted_unit_price private method below
  def apply_applicable_discount!
    update(discounted_unit_price: calculated_discounted_unit_price)
  end

  #returns the qualifying discount with the higest discount percentage
  #to be used on the qualifying invoice item(s). 
  #calls on qualifying_discountS in merchant.rb (this method returns an
  #array of AR objects aka discounts that qualified) 
  #We know which merchant we are scoped to based on the #merchant private
  #method below
  def qualifying_discount
    merchant.qualifying_discounts(self.quantity)
            .order(percentage: :desc)
            .first 
  end

  private

  #This is a calculation where we are taking the inverse of the discount 
  #percentage and multiplying this by the unit_price to return the new
  #discounted unit_price
  #calls on the qualifying_discount_percentage method below to get number
  #we need to do our the calculation with
  def calculated_discounted_unit_price
    self.unit_price * ((100 - qualifying_discount_percentage)/100.0)
  end

  #Takes the AR discount object that has the highest percentage from the
  #qualifying_discount method above and returns just the percentage (float)
  #to be used in the calculation above. If NO AR discount object is 
  #returned (aka nil), 0 is returned for the calculation.
  #Returning 0 will ensure the discounted_unit_price above will return the
  #original/un-discounted unit_price (self.unit_price * ((100 - 0)/100.0))
  def qualifying_discount_percentage
    qualifying_discount&.percentage || 0
  end

  #scopes to the merchant who's items we are working with
  def merchant 
    item.merchant 
  end
end
