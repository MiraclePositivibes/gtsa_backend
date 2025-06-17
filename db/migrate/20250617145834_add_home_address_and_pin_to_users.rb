class AddHomeAddressAndPinToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :home_address, :string
    add_column :users, :PIN, :integer
  end
end
