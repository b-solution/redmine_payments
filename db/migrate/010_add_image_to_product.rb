class AddImageToProduct< ActiveRecord::Migration
  def change
    add_column :products, :original, :string, default: nil
    add_column :products, :thumbnail, :text, default: nil
  end
end
