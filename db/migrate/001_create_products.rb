class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|

      t.string :title

      t.text :description

      t.float :price

      t.float :msrp

      t.float :unit_price

      t.string :currency

      t.integer :project_id


    end

  end
end
