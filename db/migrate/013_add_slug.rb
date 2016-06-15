class AddSlug< ActiveRecord::Migration
  def change
    add_column :products, :slug, :string, default: nil

  end
end
