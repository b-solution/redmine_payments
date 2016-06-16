class PaymentsController < ApplicationController
 unloadable
 include StripePayment
 def verify_authenticity_token

 end

 def  create_order
   card        = get_card_info(params)
   order = Order.new
   order_items = params[:order_items]
   unless order_items.present? and order_items.is_a?(Array)
     order_items = order_items.scan(/([a-z0-9-]+)/).flatten
   end
   if order_items.present? and order_items.is_a?(Array)
     product  = Product.where(product_uuid: order_items.first).first
     order.project_id = product.project_id
   end
   order       = create_customer_order(order, card, params['chargeDescription'],  params[:email])

   currency    = params[:currency]

   order.redirect_url = params[:redirect_url]

   unless order.status.present?
     if params[:action_payment] == 'authorize'
       amount = params[:amount].to_f * 100
       result = charge_customer(order, amount.to_i, currency)
       if result['paid']
         order.status = 'paid'
       else
         order.status = 'declined'
       end
     else # capture
       order.status = 'capture'
     end
   end

   order.currency = currency
   order.save

   if order_items.present? and order_items.is_a?(Array)
     order_items.each do |item|
       product  = Product.where(product_uuid: item).first
       order.add_item(product.id) if product
     end
   end
   attrs = order.attributes
   render json: attrs.except(:id)
 end

 def add_item
   order_id    = params['orderUUID']
   order = Order.where(order_uuid: order_id).first
   product  = Product.where(product_uuid: params['productUUID']).first
   result = nil
   result      = order.add_item(product.id) if product
   json        = {saved: result ? 'ok' : 'fail' }
   order_items = order.products.map(&:id)
   json.merge!('redirect_url'=> order.redirect_url)
   json.merge!('order_items'=> order_items)
   render json: json
 rescue ActiveRecord::RecordNotFound
   render json: {record_not_foud: true}
 end

 def charge_order
   order = Order.where(order_uuid: params['orderUUID']).first
   if params['productUUID']
     product  = Product.where(product_uuid: params['productUUID']).first
     order.add_item(product.id)
   end
   if order.products.blank?
     render json: {status: 'declined', error: 'no products'} and return
   end
   price = order.total_price
   currency = order.currency
   result = charge_customer(order, price * 100, currency)
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
