class AddFields< ActiveRecord::Migration
  def change
    add_column :products, :active, :boolean, default: true
    add_column :products, :group, :string, default: nil
    add_column :projects, :stripe_key, :string, default: nil

  end
end
