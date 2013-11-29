module StripeLocal
  class Customer < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    belongs_to :model, inverse_of: :customer, class_name: "::#{StripeLocal::model_class}"

    has_many   :cards, inverse_of: :customer

    has_many   :invoices, inverse_of: :customer

    has_many   :charges, inverse_of: :customer

    has_one    :subscription, inverse_of: :customer

    has_one    :plan, through: :subscription,
                   inverse_of: :members,
                       source: :plan

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

        customer = Stripe::Customer.create( params )

        lines.each do |item|
          customer.add_invoice_item( {currency: 'usd'}.merge item )
        end

        customer.update_subscription({ plan: plan })
        create( customer ).id
      end

      def create params
        super normalize params
      end

      def normalize params
        params.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :cards        then create_each_card( v.data ) and next
          when :subscription then create_subscript( v )      and next
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end

      def create_each_card cards
        cards.each do |card|
          StripeLocal::Card.create card.to_hash
        end
      end

      def create_subscript o
        StripeLocal::Subscription.create( o.to_hash ) unless o.nil?
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
#   t.integer  :model_id
#   t.timestamps

#=¡=>>>
  end
end
