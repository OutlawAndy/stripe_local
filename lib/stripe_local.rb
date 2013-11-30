require "stripe_local/engine"
require "stripe_local/webhook"

module StripeLocal

  mattr_accessor :model_class

  def stripe_customer
    StripeLocal::model_class = self
    has_one :customer, inverse_of: :model, class_name: 'StripeLocal::Customer', foreign_key: :model_id
    include InstanceMethods
  end

  module InstanceMethods

    #=!=#>>>
    #
    # this is the primary interface for subscribing.
    #
    # [params]
    #     * +card+  (required)           ->    the token returned by stripe.js
    #     * +plan+  (required)           ->    the id of the plan being subscribed to
    #     * +email+  (optional)          ->    the client's email address
    #     * +description+  (optional)    ->    a description to attach to the stripe object for future reference
    #     * +coupon+  (optional)         ->    the id of a coupon if the subscription should be discounted
    #     * +lines+   (optional)         ->    an array of (amount,description) tuples
    # ```
    #    :card => "tok_abc123",
    #    :plan => "MySaaS",
    #    :email => subscriber.email,
    #    :description => "a one year subscription to our flagship service at $99.00 per month"
    #    :lines => [
    #       [ 20000, "a one time setup fee of $200.00 for new members" ]
    #    ]
    # ```
    #=¡=#>>>

    def signup params
      plan  = params.delete( :plan )
      lines = params.delete( :lines ) || []

      customer = Stripe::Customer.create( params )

      lines.each do |item|
        customer.add_invoice_item( {currency: 'usd'}.merge item )
      end

      customer.update_subscription({ plan: plan })

      StripeLocal::Customer.create( {model_id: self.id}.merge customer.to_hash )
    end

    def customer
      @customer ||= StripeLocal::Customer.find_by( model_id: id )
    end

    def method_missing method, *args, &block
      if self.customer.present? && self.customer.respond_to?( method )
        self.customer.send method, *args, &block
      else
        super
      end
    end

    def respond_to_missing? method, include_private = false
      self.customer.present? && self.customer.respond_to?( method ) || super
    end

  end
end

ActiveRecord::Base.extend StripeLocal