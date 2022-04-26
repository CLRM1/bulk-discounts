require 'rails_helper'

RSpec.describe 'bulk discount show' do

  before(:each) do
    @merchant = Merchant.create!(name: 'Chris')
    @merchant_2 = Merchant.create!(name: 'Sophie')
  end

  it 'displays the bulk discount quantity threshold and percentage discount' do
    discount_1 = @merchant.bulk_discounts.create(percentage_discount: 10, quantity_threshold: 20)
    discount_2 = @merchant.bulk_discounts.create(percentage_discount: 25, quantity_threshold: 15)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}"

    expect(page).to have_content(discount_1.id)
    expect(page).to have_content(discount_1.percentage_discount)
    expect(page).to have_content(discount_1.quantity_threshold)
    within "#details" do
      expect(page).to_not have_content(discount_2.id)
      expect(page).to_not have_content(discount_2.percentage_discount)
      expect(page).to_not have_content(discount_2.quantity_threshold)
    end
  end

  it 'allows the user to edit the discount' do
    discount_1 = @merchant.bulk_discounts.create(percentage_discount: 10, quantity_threshold: 20)
    discount_2 = @merchant.bulk_discounts.create(percentage_discount: 25, quantity_threshold: 15)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}"

    click_link "Edit"
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}/edit")
    expect(find_field('percentage_discount').value).to eq("10")
    expect(find_field('quantity_threshold').value).to eq("20")
    fill_in 'percentage_discount', with: 22
    fill_in 'quantity_threshold', with: 2
    click_button 'Submit'

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}")
    within "#details" do
      expect(page).to_not have_content(10)
      expect(page).to_not have_content(20)
      expect(page).to have_content(22)
      expect(page).to have_content(2)
    end
  end

  it 'requires all fields to be entered when editing the discount' do
    discount_1 = @merchant.bulk_discounts.create(percentage_discount: 10, quantity_threshold: 20)
    discount_2 = @merchant.bulk_discounts.create(percentage_discount: 25, quantity_threshold: 15)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}"

    click_link "Edit"
    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}/edit")
    expect(find_field('percentage_discount').value).to eq("10")
    expect(find_field('quantity_threshold').value).to eq("20")
    fill_in 'quantity_threshold', with: 2
    fill_in 'quantity_threshold', with: nil
    click_button 'Submit'

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{discount_1.id}/edit")
  end
end
