module StripeLocal
  class Customer < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    has_one    :model, inverse_of: :customer

    has_many   :cards, inverse_of: :customer

    has_one    :default_card, ->(s){ where( id: s.read_attribute(:default_card)) }

    has_one    :subscription, inverse_of: :customer
    has_one    :discount, through: :subscription
    has_one    :plan, through: :subscription

    def metadata= hash
      MultiJson.dump hash
    end

    def metadata
      MultiJson.load read_attribute( :metadata ), symbolize_keys: true
    end

    class<<self
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
      # *returns:* _Stripe_::_Customer_._id_ which should be assign to the +:stripe_customer_id+
      # field generated when bootstrapping Engine integration.
      #
      #=¡=#>>>
      def signup params
        plan = params.delete( :plan )
        lines = params.delete( :lines ) || []

        customer = stripe_object.create( params )

        lines.each do |item|
          customer.add_invoice_item( {currency: 'usd'}.merge item )
        end unless lines.empty?

        customer.update_subscription({ plan: plan })
        create( normalize customer ).id
      end

      def create params
        super normalize params
      end

      def normalize params
        params.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :id then :customer_id
          when :cards then create_cards( v.data ) and next
          when :subscription then Subscription.create( v ) and next
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end

      def create_cards data
        data.each do |card|
          Card.create card.to_hash
        end
      end
    end

#=!=>>>
#       ~<Schema>~
#   t.string   :id
#   t.integer  :account_balance
#   t.string   :default_card
#   t.boolean  :delinquent
#   t.string   :description
#   t.string   :email
#   t.text     :metadata
#   t.timestamps

#=¡=>>>
  end
end
