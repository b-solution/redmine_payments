class CreatePriceCurrencies < ActiveRecord::Migration
  def change
    create_table :price_currencies do |t|

      t.float :price

      t.float :unit_price

      t.float :msrp

      t.string :currency

      t.string :product_id


    end

  end
end
