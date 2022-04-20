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
      click_link('GitHub Repository info')

      expect(current_path).to eq('/github_info')
    end
  end
end
