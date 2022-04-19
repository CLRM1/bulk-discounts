require 'rails_helper'


RSpec.describe 'Admin Invoice Show' do
  describe 'Admin Invoice Show Page' do
    it 'lists Invoice id, status, created at and customer name' do
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create(status: "in progress")

      visit "/admin/invoices"

      click_link "#{invoice_1.id}"
      expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
      expect(page).to have_content("#{invoice_1.id}")
      expect(page).to have_content("#{invoice_1.status}")
      expect(page).to have_content("#{invoice_1.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("Billy Jonson")

    end

    it 'lists a link to update Invoice status using a select field' do
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create(status: "in progress")

      visit "/admin/invoices/#{invoice_1.id}"

      select "cancelled" , from: :status
      click_button 'Change Status'
      expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
      expect(page).to have_content('cancelled')

    end

    it 'displays the total revenue for the invoice' do
      merchant = Merchant.create!(name: 'Brylan')
      merchant_2 = Merchant.create!(name: 'Chris')
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create(status: "in progress")
      item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 4, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 4, status: 2)
      item_3.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 4, status: 2)

      visit "/admin/invoices/#{invoice_1.id}"
      expect(page).to have_content('Total Revenue: 33')
    end
  end
end
