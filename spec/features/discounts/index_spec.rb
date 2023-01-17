require 'rails_helper'

RSpec.describe 'Merchant Discounts Index Page' do 
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @merchant_2 = Merchant.create!(name: 'Target')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant_1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant_1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @discount_1 = @merchant_1.discounts.create!(threshold: 5, percentage: 5)
    @discount_2 = @merchant_1.discounts.create!(threshold: 10, percentage: 10)
    @discount_3 = @merchant_1.discounts.create!(threshold: 25, percentage: 25)
    @discount_4 = @merchant_1.discounts.create!(threshold: 30, percentage: 30)
    @discount_5 = @merchant_1.discounts.create!(threshold: 50, percentage: 50)
    @discount_6 = @merchant_2.discounts.create!(threshold: 8, percentage: 65)

    WebMock.stub_request(:any, "https://date.nager.at/api/v3/NextPublicHolidays/US").
      to_return(
        body:
          '[
            {"date": "2023-01-16", "localName": "Martin Luther King, Jr. Day"},
            {"date": "2023-02-20", "localName": "Presidents Day"},
            {"date": "2023-04-07", "localName": "Good Friday"}
          ]',
        headers: {content_type: 'application/json'}
      )

    visit merchant_discounts_path(@merchant_1)
  end

  describe 'user story 1 (part 2)' do
    it 'displays all of the merchants discounts and the discount attributes' do 
      within(".discounts") do 
        expect(page).to_not have_css("#discount-#{@discount_6.id}")
        expect(page).to have_css("#discount-#{@discount_1.id}")
        expect(page).to have_css("#discount-#{@discount_2.id}")
        expect(page).to have_css("#discount-#{@discount_3.id}")
        expect(page).to have_css("#discount-#{@discount_4.id}")
        expect(page).to have_css("#discount-#{@discount_5.id}")
      end

      within("#discount-#{@discount_1.id}") do 
        expect(page).to have_content(@discount_1.threshold)
        expect(page).to have_content(@discount_1.percentage)
      end

      within("#discount-#{@discount_2.id}") do 
        expect(page).to have_content(@discount_2.threshold)
        expect(page).to have_content(@discount_2.percentage)
      end

      within("#discount-#{@discount_3.id}") do 
        expect(page).to have_content(@discount_3.threshold)
        expect(page).to have_content(@discount_3.percentage)
      end

      within("#discount-#{@discount_5.id}") do 
        expect(page).to have_content(@discount_5.threshold)
        expect(page).to have_content(@discount_5.percentage)
      end

      within("#discount-#{@discount_5.id}") do 
        expect(page).to have_content(@discount_5.threshold)
        expect(page).to have_content(@discount_5.percentage)
      end
    end
  end

  describe 'user story 2 (part 1)' do 
    it 'displays a link to create a new discount' do 
      expect(page).to have_link("Create a new discount")

      click_link "Create a new discount"

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1))

      visit new_merchant_discount_path(@merchant_1)
    end
  end
  describe 'user story 3' do 
    it 'displays a link to delete a discount. Once deleted it no longer appears on the index page' do 
      within("#discount-#{@discount_1.id}") do 
        expect(page).to have_link("Delete Discount ID #{@discount_1.id}")
      end

      within("#discount-#{@discount_2.id}") do 
        expect(page).to have_link("Delete Discount ID #{@discount_2.id}")
      end

      within("#discount-#{@discount_3.id}") do 
        expect(page).to have_link("Delete Discount ID #{@discount_3.id}")
      end

      within("#discount-#{@discount_4.id}") do 
        expect(page).to have_link("Delete Discount ID #{@discount_4.id}")
      end

      within("#discount-#{@discount_5.id}") do 
        expect(page).to have_link("Delete Discount ID #{@discount_5.id}")
      end

      click_link("Delete Discount ID #{@discount_5.id}")

      expect(current_path).to eq(merchant_discounts_path(@merchant_1))

      within(".discounts") do 
        expect(page).to_not have_css("#discount-#{@discount_5.id}")
      end
    end
  end

  describe 'user story 9' do 
    it 'displays an upcoming holidays section. The section contains the name and date of the next three US holidays' do 
      holiday_1 = Holiday.new(JSON.parse({date: "2023-01-16", localName: "Martin Luther King, Jr. Day"}.to_json))
      holiday_2 = Holiday.new(JSON.parse({date: "2023-02-20", localName: "Presidents Day"}.to_json))
      holiday_3 = Holiday.new(JSON.parse({date: "2023-04-07", localName: "Good Friday"}.to_json))

      within(".upcoming-holidays") do 
        expect(page).to have_content("Name: ", count: 3)
        expect(page).to have_content("Date: ", count: 3)
        expect(page).to have_css("#holiday-#{holiday_1.date}")
        expect(page).to have_css("#holiday-#{holiday_2.date}")
        expect(page).to have_css("#holiday-#{holiday_3.date}")
      end

      within("#holiday-#{holiday_1.date}") do 
        expect(page).to have_content(holiday_1.name)
        expect(page).to have_content(holiday_1.date)
      end

      within("#holiday-#{holiday_2.date}") do 
        expect(page).to have_content(holiday_2.name)
        expect(page).to have_content(holiday_2.date)
      end

      within("#holiday-#{holiday_3.date}") do 
        expect(page).to have_content(holiday_3.name)
        expect(page).to have_content(holiday_3.date)
      end
    end
  end
end