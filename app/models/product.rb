class Product < ActiveRecord::Base
  unloadable

  CURRENCIES = ['usd',  'aud',  'gbp',  'nzd',  'eur',  'mxn',
                'cop',  'brl',  'sgd',  'inr',  'php',  'ars',  'clp',  'zar',
                'sek',  'dkk',  'aed',  'sar',  'nok',  'egp',  'isk',  'rub',
                'ngn',  'chf',  'krw',  'hkd',  'twd']
  
  include Redmine::SafeAttributes
  
  safe_attributes   'title', 'description', 'project_id', 'image_url',
                    'options', 'thumbnail', 'original', 'group', 'active', 'slug'

  has_many :items
  has_many :orders, :through => :items

  has_many :price_currencies


  validates_presence_of :title, :description,:options, :project_id, :slug
  validates_uniqueness_of :slug, :scope => :project_id

  before_create :create_uuid

  def price(currency)
    price = price_currencies.where(currency: currency).first
    price ? price.price : 0
  end

  def create_uuid
    value = get_value
    while Product.where(product_uuid: value ).present?
      value = get_value
    end
    self.product_sku = value
    self.product_uuid = UUID.new.generate
  end

  def get_value
    o = [('a'..'z')].map { |i| i.to_a * 2 }.flatten.shuffle.first(2).join
    nume = [(0..9)].map { |i| i.to_a * 4 }.flatten.shuffle.first(4).join
    "#{o}#{nume}"
  end

  def to_json(currency)
    price = price_currencies.where(currency: currency).first || PriceCurrency.new(currency: currency)
    json = attributes
    p = json.merge!(price.attributes.except(:id))
    json.merge(p)
  end
end
