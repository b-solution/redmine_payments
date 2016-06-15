class AddProjectToOrder< ActiveRecord::Migration
  def change
    add_column :orders, :project_id, :integer, default: nil

  end
end
