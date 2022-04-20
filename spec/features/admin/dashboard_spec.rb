require 'rails_helper'

RSpec.describe 'Admin Dashboard' do
  describe 'As an Admin, when I visit the admin dashboard' do
    it 'Then I see a header indicating that I am on the admin dashboard' do
    visit '/admin'

    expect(page).to have_content("Admin Dashboard Page")
    end

    it 'I see links to the merchants index page' do
      visit 'admin'
      expect(current_path).to eq('/admin')
      click_link 'Admin Merchants Index'
      expect(current_path).to eq('/admin/merchants')
    end

    it 'I see links to the merchants invoice index page' do
      visit 'admin'
      click_link 'Admin Invoices Index'
      expect(current_path).to eq('/admin/invoices')
    end

    it 'should have a link to the github info page' do
      visit "/admin"
      expect(page).to have_link('GitHub Repository info')
    end

    it 'I see an "incomplete Invoices" section that lists ids of invoices with items that have not shipped yet' do
      merchant = Merchant.create!(name: 'Chris')
      item_1 = merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
      item_2 = merchant.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      item_3 = merchant.items.create!(name: 'Marker', unit_price: 400, description: 'Writes things, but dark, and thicc.')
      item_4 = merchant.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      item_5 = merchant.items.create!(name: 'Marker', unit_price: 400, description: 'Writes things, but dark, and thicc.')

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      invoice_1 = customer_1.invoices.create!(status: 'completed')
      invoice_2 = customer_1.invoices.create!(status: 'completed')
      invoice_3 = customer_1.invoices.create!(status: 'completed')
      invoice_4 = customer_1.invoices.create!(status: 'completed')
      invoice_5 = customer_1.invoices.create!(status: 'completed')
      item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_2.invoice_items.create!(invoice_id: invoice_2.id, quantity: 5, unit_price: 400, status: 'pending')
      item_3.invoice_items.create!(invoice_id: invoice_3.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_4.invoice_items.create!(invoice_id: invoice_4.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_5.invoice_items.create!(invoice_id: invoice_5.id, quantity: 5, unit_price: 400, status: 'shipped')

      visit 'admin'
      expect(page).to have_content("Incomplete Invoices")

      within '#incomplete_invoices' do
        expect(page).to have_link("#{invoice_1.id}")
        expect(page).to have_link("#{invoice_2.id}")
        expect(page).to have_link("#{invoice_3.id}")
        expect(page).to have_link("#{invoice_4.id}")
        expect(page).to_not have_link("#{invoice_5.id}")
        click_link "#{invoice_1.id}"
        expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
      end
    end
  end
end
