class CreateRedmineLeads < ActiveRecord::Migration
  def change
    create_table :redmine_leads do |t|

      t.string :uuid

      t.string :type

      t.string :website

      t.string :strategy_uuid

      t.string :click_id

      t.string :user_uuid

      t.string :email

      t.string :name

      t.string :address

      t.string :country

      t.string :city

      t.string :zip

      t.string :phone

      t.string :redirect_url


    end

  end
end
