require 'rails_helper'

RSpec.describe 'bulk discount index' do

  before(:each) do
    @merchant = Merchant.create!(name: 'Chris')
    @merchant_2 = Merchant.create!(name: 'Sophie')
    @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
    @item_2 = @merchant.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
    @item_3 = @merchant.items.create!(name: 'Marker', unit_price: 400, description: 'Writes things, but dark, and thicc.')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @invoice_1 = @customer_1.invoices.create!(status: 'completed')
    @invoice_7 = @customer_1.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-03-27 14:54:09 UTC"))
    @item_2.invoice_items.create!(invoice_id: @invoice_7.id, quantity: 5, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-03-28 14:54:09 UTC"))
    @invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249631', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249633', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')

    @customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
    @invoice_2 = @customer_2.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-03-29 14:54:09 UTC"))
    @invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249631', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249633', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249633', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249633', result: 'success')

    @customer_3 = Customer.create!(first_name: 'Toy', last_name: 'Mariah')
    @invoice_3 = @customer_3.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_3.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-03-30 14:54:09 UTC"))
    @invoice_3.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'success')
    @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'success')
    @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'success')

    @customer_4 = Customer.create!(first_name: 'Joy', last_name: 'Braun')
    @invoice_4 = @customer_4.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-04-01 14:54:09 UTC"))
    @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')

    @customer_5 = Customer.create!(first_name: 'Mark', last_name: 'Brains')
    @invoice_5 = @customer_5.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_5.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-04-02 14:54:09 UTC"))
    @invoice_5.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_5.transactions.create!(credit_card_number: '6654405418249632', result: 'success')

    @customer_6 = Customer.create!(first_name: 'Smark', last_name: 'Mrains')
    @invoice_6 = @customer_6.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_6.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                                                       created_at: Time.parse("2012-04-03 14:54:09 UTC"))
    @invoice_6.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
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
