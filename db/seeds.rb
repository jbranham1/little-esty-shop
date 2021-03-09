
if Rails.env.test?
  Rake::Task['fixtures:csv_load:all'].execute

  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
end
bulk_discount1 = BulkDiscount.create(merchant_id: 1, percentage_discount: 20, quantity_threshold:10)
bulk_discount2 = BulkDiscount.create(merchant_id: 1, percentage_discount: 30, quantity_threshold:15)
