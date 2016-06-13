class PaymentsController < ApplicationController
 unloadable
 include StripePayment

 def  create_order
   card        = get_card_info(params)
   order       = create_customer_order(card, params['chargeDescription'],  params[:email])
   order_items = params[:order_items]
   currency    = params[:currency]

   order.redirect_url = params[:redirect_url]

   unless order.status.present?
     if params[:action] == 'authorize'
       amount = params[:amount].to_f * 100
       result = charge_customer(order.charge_id_stripe, amount.to_i, currency)
       if result['paid']
         order.status = 'paid'
       else
         order.status = 'declined'
       end
     else # capture
       order.status = 'Capture'
     end
   end
   order.save

   order_items.each do |item|
     order.add_item(item)
   end
   attrs = order.attributes.merge('order_UUID' => order.id)
   render json: attrs.except(:id)
 end

 def add_item
   order_id    = params['orderUUID']
   order       = Order.find(order_id)
   product_id  = params['productUUID']
   result      = order.add_item(product_id)
   json        = {saved: result ? 'ok' : 'fail' }
   order_items = order.products.map(&:id)
   json.merge!('redirect_url'=> order.redirect_url)
   json.merge!('order_items'=> order_items)
   render json: json
 rescue ActiveRecord::RecordNotFound
   render json: {record_not_foud: true}
 end

 def charge_order
   order = Order.find(params['orderUUID'])
   order.add_item(params['productUUID']) if params['productUUID']

   cus_id = order.charge_id_stripe
   price = order.products.map(&:price).sum
   currency = order.products.first.currency
   result = charge_customer(cus_id, price, currency)
   json= {redirect_url: params[:redirect_url]}
   if result['paid']
     json.merge!(status: 'paid')
   else
     json.merge!(status: 'declined')
   end
   render json: json
 rescue ActiveRecord::RecordNotFound
   render json: {record_not_foud: true}
 end

 def add_lead
   lead = params[:lead]
   redirection = lead[:redirect_to]
   redmine_lead = RedmineLead.new
   redmine_lead.safe_attributes = lead.permit!
   json = redmine_lead.save ? {saved: true} : {saved: false}
   json.merge!(:redirect_to=> redirection)
   render json: json
 end

  private

  def get_card_info(params)
    {
        number: params[:cc],
        exp_month: params['month'],
        exp_year: params['year'],
        cvc: params['cvc'],
        name: params['fullName'],
        address_city: params['billing_city'],
        address_country: params['billing_country'],
        address_line1: params['billing_line1'],
        address_line2: params['billing_line2'],
        address_state: params['billing_state'],
        address_zip: params['billing_zip']
    }
  end

end
