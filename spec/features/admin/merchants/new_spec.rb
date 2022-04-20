require 'rails_helper'

RSpec.describe 'The New Merchant Form' do
  it 'I am taken to a form that allows me to add item information' do
    merchant = Merchant.create!(name: 'Yeti')
    merchant_2 = Merchant.create!(name: 'Hydroflask')
    item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
    item_2 = merchant.items.create!(name: 'Can', unit_price: 5, description: 'Soda')
    item_3 = merchant.items.create!(name: 'Mug', unit_price: 15, description: 'Coffee')
    item_4 = merchant_2.items.create!(name: 'Kettle', unit_price: 20, description: 'Tea')

    visit "/admin/merchants/new"
    expect(page).to have_content(:Name)

    fill_in 'name', with: 'test'
    click_button 'Submit'

  end

  it 'When I hit submit then I am taken back to the admin merchants index page' do
    visit "/admin/merchants/new"

    fill_in 'name', with: 'test_2'
    click_button 'Submit'

    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content('test_2')
    expect(page).to have_content('Status: unavailable')
  end
end


