class InvoiceItem < ApplicationRecord
  validates_presence_of :status, :quantity, :unit_price

  validates :quantity, numericality: true
  validates :unit_price, numericality: true

  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice
  has_many :merchants, through: :item
  has_many :bulk_discounts
  has_many :bulk_discounts, through: :item

  enum status: ['pending', 'packaged', 'shipped']

  def self.items_total_revenue
    sum('quantity * unit_price')
  end

  def self.incomplete_invoices
    InvoiceItem.joins(:invoice)
               .where.not(status: 'shipped')
               .order("invoices.created_at")
  end
end
