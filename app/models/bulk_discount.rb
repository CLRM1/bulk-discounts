class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, through: :merchants
  validates_presence_of :percentage_discount, :quantity_threshold
end
