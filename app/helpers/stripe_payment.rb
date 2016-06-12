module StripePayment
  require "stripe"
  Stripe.api_key = $payment_settings['secret_key']

  def create_customer_order(card, desc, email)
   cus= Stripe::Customer.create(
                        card: card,
                        description: desc,
                        email: email,
                        currency: 'usd'
   )
   order = Order.new
   order.charge_id_stripe = cus.id
   return order
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    order = Order.new
    order.status = 'failed'
    order
  end

  def charge_customer(cus_id, price, currency)
    Stripe::Charge.create(
        :amount => price,
        :currency => currency,
        :customer => cus_id
    )
  end

end