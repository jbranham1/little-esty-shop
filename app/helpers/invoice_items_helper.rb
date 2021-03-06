module InvoiceItemsHelper
  def revenue
    revenue = unit_price * quantity
    discount = BulkDiscount.bulk_discount_by_item(item_id)
    revenue.to_f - (revenue.to_f * discount)
  end
end
