require 'rails_helper'

RSpec.describe 'bulk discount index' do

  before(:each) do
    @merchant = Merchant.create!(name: 'Chris')
    @merchant_2 = Merchant.create!(name: 'Sophie')
  end

  it 'allows the user to create a new discount' do
    visit "/merchants/#{@merchant.id}/bulk_discounts"
    click_link "Create New Discount"
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
    fill_in 'percentage_discount', with: 20
    fill_in 'quantity_threshold', with: 10
    click_button 'Submit'
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
  end

  it 'allows the user to delete a discount' do
    discount_1 = @merchant.bulk_discounts.create(percentage_discount: 10, quantity_threshold: 20)
    discount_2 = @merchant.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
    discount_3 = @merchant.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 5)

    visit "/merchants/#{@merchant.id}/bulk_discounts"
    within "#discount-#{discount_1.id}" do
      expect(page).to have_content(discount_1.id)
      click_link 'Delete'
    end
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).to_not have_content(discount_1.id)

    within "#discount-#{discount_2.id}" do
      expect(page).to have_content(discount_2.id)
      click_link 'Delete'
    end
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).to_not have_content(discount_2.id)

    within "#discount-#{discount_3.id}" do
      expect(page).to have_content(discount_3.id)
      click_link 'Delete'
    end
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).to_not have_content(discount_3.id)
  end
end
