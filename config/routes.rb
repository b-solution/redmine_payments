# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html


match 'create_order', controller: 'payments', action: 'create_order', via: [:options, :post, :get ]
match'add_item', controller: 'payments', action: 'add_item' , via: [:options, :post, :get ]
match 'charge_order', controller: 'payments', action: 'charge_order', via: [:options, :post, :get ]
match 'add_lead', controller: 'payments', action: 'add_lead', via: [:options, :post, :get ]
match 'get_products', controller: 'products', action: 'get_products', via: [:options, :post, :get ]

resources :projects do
  resources :products do

  end
  post 'products/set_payment_type', controller: :products, action: :set_payment_type
end
