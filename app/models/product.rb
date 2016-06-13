class Product < ActiveRecord::Base
  unloadable
  
include Redmine::SafeAttributes
  
  safe_attributes   'title', 'description',   'price',    'msrp',
                    'unit_price',    'currency',  'project_id'

  has_many :items
  has_many :orders, :through => :items


  validates_presence_of :title, :description, :price, :msrp,
                        :unit_price, :currency, :project_id

  before_create :create_uuid

  def create_uuid
    value = get_value
    while where(order_uuid: value ).present?
      value = get_value
    end
    self.product_uuid = value
  end

  def get_value
    o = [('a'..'z')].map { |i| i.to_a * 2 }.flatten.shuffle.first(2).join
    nume = [(0..9)].map { |i| i.to_a * 4 }.flatten.shuffle.first(4).join
    "#{o}#{nume}"
  end
end
