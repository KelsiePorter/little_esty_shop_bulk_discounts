class Discount < ApplicationRecord
  validates_presence_of :percentage
  validates_presence_of :threshold
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

end