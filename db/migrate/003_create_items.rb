class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|

      t.integer :product_id

      t.integer :order_id


    end

  end
end
