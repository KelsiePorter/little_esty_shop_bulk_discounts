Discount.destroy_all

ActiveRecord::Base.connection.reset_pk_sequence!('discounts')

merchant_1 = Merchant.find(1)
merchant_2 = Merchant.find(2)

merchant_1.discounts.create!(threshold: 5, percentage: 5)
merchant_1.discounts.create!(threshold: 10, percentage: 20)
merchant_1.discounts.create!(threshold: 20, percentage: 25)
merchant_1.discounts.create!(threshold: 30, percentage: 50)
merchant_1.discounts.create!(threshold: 50, percentage: 50)
merchant_2.discounts.create!(threshold: 8, percentage: 10)
merchant_2.discounts.create!(threshold: 6, percentage: 30)
merchant_2.discounts.create!(threshold: 10, percentage: 20)
merchant_2.discounts.create!(threshold: 26, percentage: 75)
merchant_2.discounts.create!(threshold: 7, percentage: 15)
merchant_2.discounts.create!(threshold: 3, percentage: 50)
