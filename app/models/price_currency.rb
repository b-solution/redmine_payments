class PriceCurrency < ActiveRecord::Base
  unloadable
  belongs_to :product
  include Redmine::SafeAttributes

  safe_attributes   'price', 'unit_price', 'currency', 'msrp'

  validates_presence_of :price, :unit_price, :currency, :msrp

  def to_json
    json = attributes.except(:id)
    p = product.attributes.except(:id)
    json.merge(p)
  end
end
