module StripeLocal
  module InstanceDelegation
    # ==this is the primary interface for subscribing.
    #
    # params::
    #     * +card+  (required)           ->    the token returned by stripe.js
    #     * +plan+  (required)           ->    the id of the plan being subscribed to
    #     * +email+  (optional)          ->    the client's email address
    #     * +description+  (optional)    ->    a description to attach to the stripe object for future reference
    #     * +coupon+  (optional)         ->    the id of a coupon if the subscription should be discounted
    #     * +lines+   (optional)         ->    an array of (amount,description) tuples
    # example::
    #    :card => "tok_abc123",
    #    :plan => "MySaaS",
    #    :email => subscriber.email,
    #    :description => "a one year subscription to our flagship service at $99.00 per month"
    #    :lines => [
    #       [ 20000, "a one time setup fee of $200.00 for new members" ]
    #    ]
    def signup params
      plan  = params.delete( :plan )
      lines = params.delete( :lines ) || []

      _customer_ = Stripe::Customer.create( params )

      lines.each do |(amount,desc)|
        _customer_.add_invoice_item({currency: 'usd', amount: amount, description: desc})
      end
      _customer_.update_subscription({ plan: plan })

      StripeLocal::Customer.create _customer_.to_hash.reverse_merge({model_id: self.id})
    end


    def method_missing method, *args, &block
      if customer and customer.respond_to?( method, false )
        customer.send method, *args, &block
      else
        super
      end
    end

    def respond_to_missing? method, include_private = false
      super || customer and customer.respond_to?( method, false )
    end

  end

end