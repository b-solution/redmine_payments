class AddPaymentTypeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :payment_type, :string, default: nil
  end
end
