class Order < ActiveRecord::Base
  unloadable
  
  has_many :items
  has_many :products, through: :items

  include Redmine::SafeAttributes
  
  safe_attributes 'charge_id_stripe',
                  'status',
                  'customer_uuid',
                  'redirect_url'

  def add_item(product_id)
    item = Item.new(self.id, product_id)
    item.save
  end
  
end
