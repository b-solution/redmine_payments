# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'create_order', controller: 'payments', action: 'create_order'
get 'add_item', controller: 'payments', action: 'add_item'
get 'charge_order', controller: 'payments', action: 'charge_order'
get 'add_lead', controller: 'payments', action: 'add_lead'

get 'get_products', controller: 'products', action: 'get_products'

post 'create_order', controller: 'payments', action: 'create_order', via: :options
post'add_item', controller: 'payments', action: 'add_item' , via: :options
post 'charge_order', controller: 'payments', action: 'charge_order', via: :options
post 'add_lead', controller: 'payments', action: 'add_lead', via: :options

post 'get_products', controller: 'products', action: 'get_products', via: :options

resources :projects do
  resources :products do

  end
  post 'products/set_payment_type', controller: :products, action: :set_payment_type
end
