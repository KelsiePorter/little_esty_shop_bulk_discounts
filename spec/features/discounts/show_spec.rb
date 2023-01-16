require 'rails_helper'

RSpec.describe 'Merchant discount show page' do 
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @merchant_2 = Merchant.create!(name: 'Target')

    @discount_1 = @merchant_1.discounts.create!(threshold: 5, percentage: 5)
    @discount_2 = @merchant_1.discounts.create!(threshold: 10, percentage: 10)
    @discount_3 = @merchant_1.discounts.create!(threshold: 25, percentage: 25)
    @discount_4 = @merchant_1.discounts.create!(threshold: 30, percentage: 30)
    @discount_5 = @merchant_1.discounts.create!(threshold: 50, percentage: 50)
    @discount_6 = @merchant_2.discounts.create!(threshold: 8, percentage: 65)
  end
  describe 'user story 4' do 
    it 'displays the attributes of a discount' do 
      visit merchant_discount_path(@merchant_1, @discount_1)

        expect(page).to have_content(@discount_1.id)
        expect(page).to have_content(@discount_1.threshold)
        expect(page).to have_content(@discount_1.percentage)
        expect(page).to_not have_content(@discount_2.id)

      visit merchant_discount_path(@merchant_2, @discount_6)

      expect(page).to have_content(@discount_6.id)
      expect(page).to have_content(@discount_6.threshold)
      expect(page).to have_content(@discount_6.percentage)
    end
  end
  
  describe 'user story 5 (part 1)' do 
    it 'displays a link to edit the discount' do 
      visit merchant_discount_path(@merchant_1, @discount_1)

      expect(page).to have_link("Edit Discount")

      click_link("Edit Discount")

      expect(current_path).to eq(edit_merchant_discount_path(@merchant_1, @discount_1))
    end
  end
end