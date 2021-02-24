require 'csv'

namespace :fixtures do
  namespace :csv_load do
    desc "Import merchants from csv file to test environment"

    task merchants: :environment do
      ActiveRecord::Base.establish_connection('test')
      Merchant.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('merchants')

      file = "spec/fixtures/merchants_test.csv"

      CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        Merchant.create!(row.to_hash)
      end
    end

    desc "Import invoice items from csv file"

    task invoice_items: :environment do
      ActiveRecord::Base.establish_connection('test')
      InvoiceItem.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')

      file = "spec/fixtures/invoice_items_test.csv"

      CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        InvoiceItem.create!(row.to_hash)
      end
    end

    desc "Import items from csv file"

    task items: :environment do
      ActiveRecord::Base.establish_connection('test')
      Item.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('items')

      file = "spec/fixtures/items_test.csv"

      CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        Item.create!(row.to_hash)
      end
    end

    desc "Import invoices from csv file"

    task invoices: :environment do
      ActiveRecord::Base.establish_connection('test')
      Invoice.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('invoices')

      file = "spec/fixtures/invoices_test.csv"

      CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        if row[:status] == "in progress"
          row[:status] = "in_progress"
        end

        Invoice.create!(row.to_hash)
      end
    end

    desc "Import transactions from csv file"

    task transactions: :environment do
      ActiveRecord::Base.establish_connection('test')
      Transaction.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('transactions')

      file = "spec/fixtures/transactions_test.csv"

      CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        Transaction.create!(row.to_hash)
      end
    end

    desc "Import customers from csv file"

    task customers: :environment do
      ActiveRecord::Base.establish_connection('test')
      Customer.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('customers')

      file = "spec/fixtures/customers_test.csv"

      CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
        Customer.create!(row.to_hash)
      end
    end

    desc "Import all csv files"

    task all: :environment do
      ActiveRecord::Base.establish_connection('test')
      tasks = [ 'csv_load:merchants',
                'csv_load:items',
                'csv_load:customers',
                'csv_load:invoices',
                'csv_load:transactions',
                'csv_load:invoice_items']

      tasks.each do |task|
        Rake::Task[task].execute
      end
    end
  end
end
