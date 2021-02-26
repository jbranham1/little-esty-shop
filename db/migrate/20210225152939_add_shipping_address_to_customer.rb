class AddShippingAddressToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :address, :string, default: ''
    add_column :customers, :city, :string, default: ''
    add_column :customers, :state, :string, default: ''
    add_column :customers, :zipcode, :string, default: ''
  end
end
