require 'rails_helper'


RSpec.describe 'Admin Invoice Index' do
  describe 'Admin Invoice Index Page' do
    it 'lists each Invoice id in the system' do
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create(status: "in progress")
      invoice_2 = customer.invoices.create(status: "in progress")
      invoice_3 = customer.invoices.create(status: "in progress")

      visit "/admin/invoices"
      expect(page).to have_link("#{invoice_1.id}")
      expect(page).to have_link("#{invoice_2.id}")
      expect(page).to have_link("#{invoice_3.id}")
    end

    it 'should have a link to the github info page' do
      visit "/admin/invoices"
      click_link('GitHub Repository info')

      expect(current_path).to eq('/github_info')
    end
  end
end
