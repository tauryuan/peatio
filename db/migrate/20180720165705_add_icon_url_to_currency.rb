class AddIconUrlToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :icon_url, :string
  end
end
