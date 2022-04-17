require 'rails_helper'

RSpec.describe Merchant do
  before :each do
    @merchant = Merchant.create!(name: "Frank's Pudding",
                            created_at: Time.parse('2012-03-27 14:53:59 UTC'),
                            updated_at: Time.parse('2012-03-27 14:53:59 UTC'))
    @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 5, description: 'Writes things.')
    @item_2 = @merchant.items.create!(name: 'Pen', unit_price: 4, description: 'Writes things, but dark.')
    @item_3 = @merchant.items.create!(name: 'Marker', unit_price: 4, description: 'Writes things, but dark, and thicc.')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @invoice_1 = @customer_1.invoices.create!(status: 'completed')
    @invoice_7 = @customer_1.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 4, status: 'packaged')
    @item_2.invoice_items.create!(invoice_id: @invoice_7.id, quantity: 5, unit_price: 4, status: 'packaged')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249631', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249633', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')

    @customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
    @invoice_2 = @customer_2.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 3, unit_price: 4, status: 2)
    @invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249631', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249633', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249633', result: 'success')
    @invoice_2.transactions.create!(credit_card_number: '5654405418249633', result: 'success')

    @customer_3 = Customer.create!(first_name: 'Toy', last_name: 'Mariah')
    @invoice_3 = @customer_3.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_3.id, quantity: 3, unit_price: 4, status: 2)
    @invoice_3.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'success')
    @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'success')
    @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'success')

    @customer_4 = Customer.create!(first_name: 'Joy', last_name: 'Braun')
    @invoice_4 = @customer_4.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 3, unit_price: 4, status: 2)
    @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')

    @customer_5 = Customer.create!(first_name: 'Mark', last_name: 'Brains')
    @invoice_5 = @customer_5.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_5.id, quantity: 3, unit_price: 4, status: 2)
    @invoice_5.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_5.transactions.create!(credit_card_number: '6654405418249632', result: 'success')

    @customer_6 = Customer.create!(first_name: 'Smark', last_name: 'Mrains')
    @invoice_6 = @customer_6.invoices.create!(status: 'completed')
    @item_1.invoice_items.create!(invoice_id: @invoice_6.id, quantity: 3, unit_price: 4, status: 2)
    @invoice_6.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
  end

  context 'readable attributes' do
    it 'has a name' do
      expect(@merchant.name).to eq("Frank's Pudding")
    end
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  context 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  context 'instance methods' do
    it '.top_five_customers returns best customers based on transactions' do
      expect(@merchant.top_five_customers).to eq([@customer_1, @customer_2, @customer_3, @customer_4, @customer_5])
    end

    it 'can return the top five items revenue' do

      item_2 = @merchant.items.create!(name: 'Eraser', unit_price: 2, description: 'Does things.')
      item_3 = @merchant.items.create!(name: 'Pen', unit_price: 3, description: 'Helps things.')
      item_4 = @merchant.items.create!(name: 'Calculator', unit_price: 4, description: 'Considers things.')
      item_5 = @merchant.items.create!(name: 'Stapler', unit_price: 5, description: 'Wishes things.')
      item_6 = @merchant.items.create!(name: 'Computer', unit_price: 6, description: 'Hopes things.')
      item_7 = @merchant.items.create!(name: 'Backpack', unit_price: 7, description: 'Forgets things.')
      item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 2, unit_price: 5, status: 2)
      item_3.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 6, status: 2)
      item_4.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 4, unit_price: 7, status: 2)
      item_5.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 5, unit_price: 8, status: 2)

      item_3.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 1, unit_price: 4, status: 2)
      item_4.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 2, unit_price: 5, status: 2)
      item_5.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 3, unit_price: 6, status: 2)
      item_6.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 4, unit_price: 7, status: 2)
      item_7.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 5, unit_price: 8, status: 2)

      expect(@merchant.top_five_items_by_revenue).to eq([item_5, @item_1, item_4, item_7, item_6])
    end

    it ".items_ready_to_ship returns items with invoice_items that have 'packaged' status" do
      expect(@merchant.items_ready_to_ship).to eq([@item_1, @item_2])
    end

    it '.total_revenue returns the total revenue of merchants with at least 1 successful transaction' do
      merchant = Merchant.create!(name: 'Brylan')
      item_1 = merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      invoice_1 = customer_1.invoices.create!(status: 'completed')
      item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged')

      merchant_2 = Merchant.create!(name: 'Chris')
      item_2 = merchant_2.items.create!(name: 'Marker', unit_price: 400, description: 'Writes things, but dark, and thicc.')
      customer_2 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
      invoice_2 = customer_2.invoices.create!(status: 'completed')
      invoice_2.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_3 = customer_2.invoices.create!(status: 'completed')
      invoice_3.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      item_2.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_2.invoice_items.create!(invoice_id: invoice_3.id, quantity: 5, unit_price: 400, status: 'packaged')

      merchant_3 = Merchant.create!(name: 'Antonio')
      item_3 = merchant_3.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      customer_3 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
      invoice_4 = customer_3.invoices.create!(status: 'completed')
      invoice_4.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_5 = customer_3.invoices.create!(status: 'completed')
      invoice_5.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_6 = customer_3.invoices.create!(status: 'completed')
      invoice_6.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      item_3.invoice_items.create!(invoice_id: invoice_4.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_3.invoice_items.create!(invoice_id: invoice_5.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_3.invoice_items.create!(invoice_id: invoice_6.id, quantity: 5, unit_price: 400, status: 'packaged')

      merchant_4 = Merchant.create!(name: 'Craig')
      item_4 = merchant_4.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      customer_4 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
      invoice_7 = customer_4.invoices.create!(status: 'completed')
      invoice_7.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_8 = customer_4.invoices.create!(status: 'completed')
      invoice_8.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_9 = customer_4.invoices.create!(status: 'completed')
      invoice_9.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_10 = customer_4.invoices.create!(status: 'completed')
      invoice_10.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      item_4.invoice_items.create!(invoice_id: invoice_7.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_4.invoice_items.create!(invoice_id: invoice_8.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_4.invoice_items.create!(invoice_id: invoice_9.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_4.invoice_items.create!(invoice_id: invoice_10.id, quantity: 5, unit_price: 400, status: 'packaged')

      merchant_5 = Merchant.create!(name: 'Horacio')
      item_5 = merchant_5.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      customer_5 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
      invoice_11 = customer_5.invoices.create!(status: 'completed')
      invoice_11.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_12 = customer_5.invoices.create!(status: 'completed')
      invoice_12.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_13 = customer_5.invoices.create!(status: 'completed')
      invoice_13.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_14 = customer_5.invoices.create!(status: 'completed')
      invoice_14.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_15 = customer_5.invoices.create!(status: 'completed')
      invoice_15.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      item_5.invoice_items.create!(invoice_id: invoice_11.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_5.invoice_items.create!(invoice_id: invoice_12.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_5.invoice_items.create!(invoice_id: invoice_13.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_5.invoice_items.create!(invoice_id: invoice_14.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_5.invoice_items.create!(invoice_id: invoice_15.id, quantity: 5, unit_price: 400, status: 'packaged')

      merchant_6 = Merchant.create!(name: 'Dr. Phil')
      item_6 = merchant_6.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      customer_6 = Customer.create!(first_name: 'Robert', last_name: 'Jones')
      invoice_16 = customer_6.invoices.create!(status: 'completed')
      invoice_16.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_17 = customer_6.invoices.create!(status: 'completed')
      invoice_17.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_18 = customer_6.invoices.create!(status: 'completed')
      invoice_18.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_19 = customer_6.invoices.create!(status: 'completed')
      invoice_19.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_20 = customer_6.invoices.create!(status: 'completed')
      invoice_20.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_21 = customer_6.invoices.create!(status: 'completed')
      invoice_21.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      item_6.invoice_items.create!(invoice_id: invoice_16.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_6.invoice_items.create!(invoice_id: invoice_17.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_6.invoice_items.create!(invoice_id: invoice_18.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_6.invoice_items.create!(invoice_id: invoice_19.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_6.invoice_items.create!(invoice_id: invoice_20.id, quantity: 5, unit_price: 400, status: 'packaged')
      item_6.invoice_items.create!(invoice_id: invoice_21.id, quantity: 5, unit_price: 400, status: 'packaged')

      merchant_failed = Merchant.create!(name: 'Dilbert')
      item_failed = merchant_failed.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
      customer_failed = Customer.create!(first_name: 'Robert', last_name: 'Jones')
      invoice_failed_1 = customer_failed.invoices.create!(status: 'completed')
      invoice_failed_1.transactions.create!(credit_card_number: '0898987987978', result: 'success')
      invoice_failed_2 = customer_failed.invoices.create!(status: 'completed')
      invoice_failed_2.transactions.create!(credit_card_number: '0898987987978', result: 'failed')
      item_failed.invoice_items.create!(invoice_id: invoice_failed_1.id, quantity: 3, unit_price: 400, status: 'packaged')
      item_failed.invoice_items.create!(invoice_id: invoice_failed_2.id, quantity: 5, unit_price: 400, status: 'packaged')

      expect(merchant_failed.total_revenue).to eq(1200)
      expect(merchant_1.total_revenue).to eq(1200)
      expect(merhant_2.total_revenue).to eq(3200)
      expect(merhant_3.total_revenue).to eq(5200)
      expect(merhant_4.total_revenue).to eq(7200)
      expect(merhant_5.total_revenue).to eq(9200)
      expect(merhant_6.total_revenue).to eq(11200)
    end
  end
end
