module StripePayment
  require "stripe"

  def set_key_api(order)
    stripe_key = order.project.stripe_key
    Stripe.api_key = stripe_key
  end

  def create_customer_order(order, card, desc, email)
    set_key_api(order)
    customer_uuid = UUID.new.generate
    order.customer_uuid = customer_uuid
    order.save
    begin
      cus = Stripe::Customer.create(
          card: card,
          description: desc,
          email: email,
          metadata: {customer_uuid: customer_uuid,
                     order_id: order.id}
      )
      order.charge_id_stripe = cus.id
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      order.status = 'failed'
    end
    order
  end

  def charge_customer(order, price, currency)
    set_key_api(order)
    cus_id = order.charge_id_stripe
    Stripe::Charge.create(
        :amount => price.to_i * 100,
        :currency => currency,
        :customer => cus_id
    )
  end

end