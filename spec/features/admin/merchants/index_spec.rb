require 'rails_helper'


RSpec.describe 'Admin Merchant Index' do
  describe 'Admin Merchant Index Page' do
    it 'lists each merchant in the system' do
      merchant_1 = Merchant.create!(name: 'Brylan')
      merchant_2 = Merchant.create!(name: 'Antonio')
      merchant_3 = Merchant.create!(name: 'Chris')
      merchant_4 = Merchant.create!(name: 'Craig')

      visit "/admin/merchants"

      expect(page).to have_content('Brylan')
      expect(page).to have_content('Antonio')
      expect(page).to have_content('Chris')
      expect(page).to have_content('Craig')

    end

    it 'has link to each merchant show page by clicking name' do
      merchant_1 = Merchant.create!(name: 'Brylan')
      visit "/admin/merchants"

      click_link "Brylan"
      expect(current_path).to eq("/admin/merchants/#{merchant_1.id}")
    end

    describe 'top_5_merchants' do
      before :each do
        @merchant = Merchant.create!(name: 'Brylan')
        @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
        @invoice_1 = @customer_1.invoices.create!(status: 'completed')
        @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged')

        @merchant_2 = Merchant.create!(name: 'Chris')
        @item_2 = @merchant_2.items.create!(name: 'Marker', unit_price: 400, description: 'Writes things, but dark, and thicc.')
        @customer_2 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
        @invoice_2 = @customer_2.invoices.create!(status: 'completed')
        @invoice_2.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_3 = @customer_2.invoices.create!(status: 'completed')
        @invoice_3.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @item_2.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 3, unit_price: 400, status: 'packaged')
        @item_2.invoice_items.create!(invoice_id: @invoice_3.id, quantity: 5, unit_price: 400, status: 'packaged')

        @merchant_3 = Merchant.create!(name: 'Antonio')
        @item_3 = @merchant_3.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
        @customer_3 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
        @invoice_4 = @customer_3.invoices.create!(status: 'completed')
        @invoice_4.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_5 = @customer_3.invoices.create!(status: 'completed')
        @invoice_5.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_6 = @customer_3.invoices.create!(status: 'completed')
        @invoice_6.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @item_3.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 3, unit_price: 400, status: 'packaged')
        @item_3.invoice_items.create!(invoice_id: @invoice_5.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_3.invoice_items.create!(invoice_id: @invoice_6.id, quantity: 5, unit_price: 400, status: 'packaged')

        @merchant_4 = Merchant.create!(name: 'Craig')
        @item_4 = @merchant_4.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
        @customer_4 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
        @invoice_7 = @customer_4.invoices.create!(status: 'completed')
        @invoice_7.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_8 = @customer_4.invoices.create!(status: 'completed')
        @invoice_8.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_9 = @customer_4.invoices.create!(status: 'completed')
        @invoice_9.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_10 = @customer_4.invoices.create!(status: 'completed')
        @invoice_10.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @item_4.invoice_items.create!(invoice_id: @invoice_7.id, quantity: 3, unit_price: 400, status: 'packaged')
        @item_4.invoice_items.create!(invoice_id: @invoice_8.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_4.invoice_items.create!(invoice_id: @invoice_9.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_4.invoice_items.create!(invoice_id: @invoice_10.id, quantity: 5, unit_price: 400, status: 'packaged')

        @merchant_5 = Merchant.create!(name: 'Horacio')
        @item_5 = @merchant_5.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
        @customer_5 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
        @invoice_11 = @customer_5.invoices.create!(status: 'completed')
        @invoice_11.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_12 = @customer_5.invoices.create!(status: 'completed')
        @invoice_12.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_13 = @customer_5.invoices.create!(status: 'completed')
        @invoice_13.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_14 = @customer_5.invoices.create!(status: 'completed')
        @invoice_14.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_15 = @customer_5.invoices.create!(status: 'completed')
        @invoice_15.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @item_5.invoice_items.create!(invoice_id: @invoice_11.id, quantity: 3, unit_price: 400, status: 'packaged')
        @item_5.invoice_items.create!(invoice_id: @invoice_12.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_5.invoice_items.create!(invoice_id: @invoice_13.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_5.invoice_items.create!(invoice_id: @invoice_14.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_5.invoice_items.create!(invoice_id: @invoice_15.id, quantity: 5, unit_price: 400, status: 'packaged')

        @merchant_6 = Merchant.create!(name: 'Dr. Phil')
        @item_6 = @merchant_6.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
        @customer_6 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
        @invoice_16 = @customer_6.invoices.create!(status: 'completed')
        @invoice_16.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_17 = @customer_6.invoices.create!(status: 'completed')
        @invoice_17.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_18 = @customer_6.invoices.create!(status: 'completed')
        @invoice_18.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_19 = @customer_6.invoices.create!(status: 'completed')
        @invoice_19.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_20 = @customer_6.invoices.create!(status: 'completed')
        @invoice_20.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_21 = @customer_6.invoices.create!(status: 'completed')
        @invoice_21.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @item_6.invoice_items.create!(invoice_id: @invoice_16.id, quantity: 3, unit_price: 400, status: 'packaged')
        @item_6.invoice_items.create!(invoice_id: @invoice_17.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_6.invoice_items.create!(invoice_id: @invoice_18.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_6.invoice_items.create!(invoice_id: @invoice_19.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_6.invoice_items.create!(invoice_id: @invoice_20.id, quantity: 5, unit_price: 400, status: 'packaged')
        @item_6.invoice_items.create!(invoice_id: @invoice_21.id, quantity: 5, unit_price: 400, status: 'packaged')

        @merchant_failed = Merchant.create!(name: 'Dilbert')
        @item_failed = @merchant_failed.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
        @customer_failed = Customer.create!(first_name: 'Robert', last_name: 'Jones')
        @invoice_failed_1 = @customer_failed.invoices.create!(status: 'completed')
        @invoice_failed_1.transactions.create!(credit_card_number: '0898987987978', result: 'success')
        @invoice_failed_2 = @customer_failed.invoices.create!(status: 'completed')
        @invoice_failed_2.transactions.create!(credit_card_number: '0898987987978', result: 'failed')
        @item_failed.invoice_items.create!(invoice_id: @invoice_failed_1.id, quantity: 3, unit_price: 400, status: 'packaged')
        @item_failed.invoice_items.create!(invoice_id: @invoice_failed_2.id, quantity: 5, unit_price: 400, status: 'packaged')

        visit '/admin/merchants'
      end

      it 'has a top_5_merchants section' do
        within '#top_5_merchants' do
          expect(page).to_not have_content('Brylan')
          expect(page).to_not have_content('Dilbert')
          expect('Dr. Phil').to appear_before('Horacio')
          expect('Horacio').to appear_before('Craig')
          expect('Craig').to appear_before('Antonio')
          expect('Antonio').to appear_before('Chris')
        end
      end

      it 'displays the total revenue generated next to each merchant name' do
        within("#merchant-#{@merchant_2.id}") do
          expect(page).to have_content("Total Revenue: $32.00")
        end

        within("#merchant-#{@merchant_3.id}") do
          expect(page).to have_content("Total Revenue: $52.00")
        end

        within("#merchant-#{@merchant_4.id}") do
          expect(page).to have_content("Total Revenue: $72.00")
        end

        within("#merchant-#{@merchant_5.id}") do
          expect(page).to have_content("Total Revenue: $92.00")
        end

        within("#merchant-#{@merchant_6.id}") do
          expect(page).to have_content("Total Revenue: $112.00")
        end
      end
    end
  end
end
