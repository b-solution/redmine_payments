class Item < ActiveRecord::Base
  unloadable

  belongs_to :product
  belongs_to :order
end
