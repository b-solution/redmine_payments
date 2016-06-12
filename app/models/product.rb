class Product < ActiveRecord::Base
  unloadable
  
include Redmine::SafeAttributes
  
  safe_attributes   'title', 'description',   'price',    'msrp',
                    'unit_price',    'currency',  'project_id'

  has_many :items
  has_many :orders, :through => :items


  validates_presence_of :title, :description, :price, :msrp,
                        :unit_price, :currency, :project_id
end
