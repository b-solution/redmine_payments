class AddSku< ActiveRecord::Migration
  def change
    add_column :products, :product_sku, :string, default: nil
    add_column :products, :options, :text, default: nil
    add_column :products, :image_url, :string, default: nil

    remove_column :products, :msrp, :string, default: nil
    remove_column :products, :price, :string, default: nil
    remove_column :products, :currency, :string, default: nil
    remove_column :products, :unit_price, :string, default: nil

  end
end
