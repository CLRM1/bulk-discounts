class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchant, through: :items

  enum status: ['in progress', 'cancelled', 'completed']

  def get_invoice_item(item_id)
    invoice_items.find_by(item_id: item_id)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    gross_revenue = total_revenue
     # a  = select.("merchants.*, bulk_discounts.* FROM bulk_discounts JOIN merchants ON merchants.id = bulk_discounts.merchant_id")
    # require 'pry'; binding.pry
    customer_id = self.customer_id
    customer = Customer.find(customer_id)
    invoices = customer.invoices
    merchant = invoices.first.merchant
    discounts = merchant.first.bulk_discounts

    if discounts.first.percentage_discount != nil && discounts.first.quantity_threshold != nil
      percentage_discount = discounts.first.percentage_discount
      quantity_threshold = discounts.first.quantity_threshold
      new_price = 0
    end

    if invoice_items.first.quantity >= quantity_threshold
      discounted_amount = (((invoice_items.first.unit_price) * 0.20) * invoice_items.first.quantity)
    end
    new_price = gross_revenue - discounted_amount

    # select *. discounts from customer.invoices.merchant.bulk_discounts
    # joins customers and bulk discounts
    # where
    # group by

  end
end
