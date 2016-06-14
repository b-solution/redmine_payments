class AddCurrencyToOrder< ActiveRecord::Migration
  def change
    add_column :orders, :currency, :string, default: 'usd'

  end
end
