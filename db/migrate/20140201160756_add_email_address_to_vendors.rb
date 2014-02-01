class AddEmailAddressToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :email_address, :string
  end
end
