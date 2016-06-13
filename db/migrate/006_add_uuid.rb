class AddUuid < ActiveRecord::Migration
  def change
    add_column :orders, :order_uuid, :string, default: nil
    add_column :products, :product_uuid, :string, default: nil
  end
end
