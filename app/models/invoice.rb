class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: ['in progress', 'cancelled', 'completed']

  def get_invoice_item(item_id)
    invoice_items.find_by(item_id: item_id)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    gross_revenue = total_revenue
    discount = InvoiceItem.joins(:bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .select('invoice_items.id, (invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percentage_discount/100.00)) as discount')
      .group('bulk_discounts.percentage_discount','invoice_items.id')
      .sum(&:discount)
    total_discounted_revenue = gross_revenue - discount.to_i
    total_discounted_revenue
  end
end
