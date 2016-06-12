class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.string :charge_id_stripe

      t.string :status

      t.string :customer_uuid

      t.string :redirect_url


    end

  end
end
