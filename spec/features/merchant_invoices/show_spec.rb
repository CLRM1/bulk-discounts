require 'rails_helper'

RSpec.describe 'merchant invoice show page' do

  before(:each) do
    @merchant = Merchant.create!(name: 'Brylan')
    @merchant_2 = Merchant.create!(name: 'Chris')

    @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
    @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')

    @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
    @invoice_1 = @customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
    @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 10, unit_price: 100, status: 2)
    @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 2)

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
        expect(page).to have_content("Quantity: 3")
        expect(page).to have_content("Price per Item: $4.00")
        expect(page).to have_content("Status: shipped")
      end
    end

    it "displays the total revenue for all items on the invoice" do
      expect(page).to have_content("Total Revenue: $22.00")
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

    it 'displays the total discounted revenue for the merchant from the invoice (ex1)' do
      merchant = Merchant.create!(name: 'Chris')
      discount_1 = merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 3, description: 'Soda')
      item_3 = merchant.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice = customer.invoices.create(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      item_1.invoice_items.create!(invoice_id: invoice.id, quantity: 10, unit_price: 100, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice.id, quantity: 3, unit_price: 400, status: 2)
      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"
      expect(page).to have_content("Total Revenue: $22.00")
      expect(page).to have_content("Total Discounted Revenue: $20.00")
    end

    it 'displays the total discounted revenue when there are two discounts and both meet the threshold (ex3)' do
      merchant = Merchant.create!(name: 'Chris')
      discount_1 = merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      discount_2 = merchant.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 3, description: 'Soda')
      item_3 = merchant.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice = customer.invoices.create(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      item_1.invoice_items.create!(invoice_id: invoice.id, quantity: 12, unit_price: 100, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice.id, quantity: 15, unit_price: 400, status: 2)
      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"
      expect(page).to have_content("Total Revenue: $72.00")
      expect(page).to have_content("Total Discounted Revenue: $51.60")
    end

    it 'displays the total discounted revenue when there are two discounts and both meet the threshold of the first (ex4)' do
      merchant = Merchant.create!(name: 'Chris')
      discount_1 = merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      discount_2 = merchant.bulk_discounts.create(percentage_discount: 15, quantity_threshold: 15)
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 3, description: 'Soda')
      item_3 = merchant.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice = customer.invoices.create(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      item_1.invoice_items.create!(invoice_id: invoice.id, quantity: 12, unit_price: 100, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice.id, quantity: 15, unit_price: 400, status: 2)
      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"
      expect(page).to have_content("Total Revenue: $72.00")
      expect(page).to have_content("Total Discounted Revenue: $57.60")
    end

    it 'displays the total discounted revenue when there are two merchants (ex5)' do
      merchant = Merchant.create!(name: 'Chris')
      merchant_b = Merchant.create!(name: 'Sophie')
      discount_1 = merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      discount_2 = merchant.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 3, description: 'Soda')
      item_3 = merchant.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      item_4 = merchant_b.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice = customer.invoices.create(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      item_1.invoice_items.create!(invoice_id: invoice.id, quantity: 12, unit_price: 100, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice.id, quantity: 15, unit_price: 400, status: 2)
      item_4.invoice_items.create!(invoice_id: invoice.id, quantity: 15, unit_price: 400, status: 2)
      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"
      expect(page).to have_content("Total Revenue: $132.00")
      expect(page).to have_content("Total Discounted Revenue: $111.60")
    end

    it 'has links to applied discounts' do
      merchant = Merchant.create!(name: 'Chris')
      discount_1 = merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 3, description: 'Soda')
      item_3 = merchant.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice = customer.invoices.create(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      item_1.invoice_items.create!(invoice_id: invoice.id, quantity: 10, unit_price: 100, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice.id, quantity: 3, unit_price: 400, status: 2)
      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"
      within "#item-#{item_1.id}" do
        click_link "Bulk Discount"
        expect(current_path).to eq("/merchants/#{merchant.id}/bulk_discounts/#{discount_1.id}")
      end
      expect(page).to have_content(discount_1.id)
    end
  end
end
