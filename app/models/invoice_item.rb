class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price, :status
  belongs_to :item
  belongs_to :invoice

  enum status: {'pending': 0, 'packaged': 1, 'shipped': 2}
end