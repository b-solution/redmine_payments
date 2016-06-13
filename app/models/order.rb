class Order < ActiveRecord::Base
  unloadable
  
  has_many :items
  has_many :products, through: :items

  include Redmine::SafeAttributes
  
  safe_attributes 'charge_id_stripe',
                  'status',
                  'customer_uuid',
                  'redirect_url'

  before_create :create_uuid

  def add_item(product_id)
    item = Item.new(self.id, product_id)
    item.save
  end

  def create_uuid
    value = get_value
    while where(order_uuid: value ).present?
      value = get_value
    end
    self.order_uuid = value
  end

  def get_value
    o = [('a'..'z')].map { |i| i.to_a * 2 }.flatten.shuffle.first(2).join
    nume = [(0..9)].map { |i| i.to_a * 4 }.flatten.shuffle.first(4).join
    "#{o}#{nume}"
  end
end
