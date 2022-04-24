require 'rails_helper'

RSpec.describe 'merchant invoice show page' do

  before(:each) do
    @merchant = Merchant.create!(name: 'Brylan')
    @merchant_2 = Merchant.create!(name: 'Chris')

    @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
    @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
    # @item_3 = @merchant.items.create!(name: 'Mat', unit_price: 500, description: 'Soda')
    # @item_4 = @merchant.items.create!(name: 'Sheet', unit_price: 500, description: 'Soda')
    # @item_5 = @merchant.items.create!(name: 'Sock', unit_price: 500, description: 'Soda')
    # @item_6 = @merchant.items.create!(name: 'Hat', unit_price: 500, description: 'Soda')
    # @item_7 = @merchant.items.create!(name: 'Bag', unit_price: 500, description: 'Soda')
    # @item_8 = @merchant.items.create!(name: 'Wallet', unit_price: 500, description: 'Soda')
    # @item_9 = @merchant.items.create!(name: 'Purse', unit_price: 500, description: 'Soda')
    # @item_10 = @merchant.items.create!(name: 'Hammer', unit_price: 500, description: 'Soda')
    # @item_11 = @merchant_2.items.create!(name: 'Quilt', unit_price: 400, description: 'Jelly')

    @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
    @invoice_1 = @customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
    @invoice_1.invoice_items.create!(item_id: @item_1.id, status: "shipped", quantity: 10, unit_price: 100)
    @invoice_1.invoice_items.create!(item_id: @item_2.id, status: "packaged", quantity: 5, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_3.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_4.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_5.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_6.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_7.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_8.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_9.id, status: "packaged", quantity: 10, unit_price: 500)
    # @invoice_1.invoice_items.create!(item_id: @item_10.id, status: "packaged", quantity: 10, unit_price: 500)

    visit "/merchants/#{@merchant.id}/invoices/#{@invoice_1.id}"
  end

  it "displays information related to the invoice" do
    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content("in progress")
    expect(page).to have_content("Tuesday, April 12, 2022")
    expect(page).to have_content("Billy")
    expect(page).to have_content("Jonson")
  end

  context 'invoice items' do
    it 'should show the names of all items related to the invoice' do
      expect(page).to have_content("Bottle")
      expect(page).to have_content("Can")
      expect(page).to_not have_content("Jar")
    end

    it 'next to each item should be its quantity, price, and invoice_item status' do
      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Quantity: 10")
        expect(page).to have_content("Price per Item: $1.00")
        expect(page).to have_content("Status: shipped")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content("Quantity: 5")
        expect(page).to have_content("Price per Item: $5.00")
        expect(page).to have_content("Status: packaged")
      end
    end

    it "displays the total revenue for all items on the invoice" do
      expect(page).to have_content("Total Revenue: $35.00")
    end

    it 'displays a select box to change an invoice_item status' do
      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Status: shipped")
      end

      within "#item-#{@item_1.id}" do
        select 'packaged', from: 'select_status'
        click_button "Update Item Status"
      end

      expect(current_path).to eq("/merchants/#{@merchant.id}/invoices/#{@invoice_1.id}")

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Status: packaged")
      end
    end

    # Merchant Invoice Show Page: Total Revenue and Discounted Revenue
#
    # As a merchant
    # When I visit my merchant invoice show page
    # Then I see the total revenue for my merchant from this invoice (not including discounts)
    # And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
    it 'displays the total discounted revenue for the merchant from the invoice (20% for 10 items)' do
      discount_1 = @merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      expect(page).to have_content("Total Revenue: $35.00")
      expect(page).to have_content("Total Discounted Revenue: $33.00")
    end
  end
end
