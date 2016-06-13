module StripePayment
  require "stripe"
  Stripe.api_key = $payment_settings['stripe']['secret_key']

  def create_customer_order(card, desc, email)
    customer_uuid = Order.new.get_value
    order = Order.new
    order.customer_uuid = customer_uuid
    begin
      cus= Stripe::Customer.create(
          card: card,
          description: desc,
          email: email,
          metadata: {customer_uuid: customer_uuid}
      )
      order.charge_id_stripe = cus.id
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      order.status = 'failed'
    end
    order
  end

  def charge_customer(cus_id, price, currency)
    Stripe::Charge.create(
        :amount => price.to_i,
        :currency => currency,
        :customer => cus_id
    )
  end

end