module StripeLocal
  module AssociationMethods
    def customer
      @customer ||= StripeLocal::Customer.find_by( model_id: id )
    end

    def subscription
      @subscription ||= StripeLocal::Subscription.find_by( customer_id: customer.id )
    end

    def cards
      @cards ||= StripeLocal::Card.where( customer_id: customer.id )
    end

    def plan
      @plan ||= StripeLocal::Plan.find_by( id: subscription.plan_id )
    end

    def discount
      @discount ||= StripeLocal::Discount.find_by( customer_id: customer.id )
    end

    def coupon
      @coupon ||= StripeLocal::Coupon.find_by( id: discount.coupon_id )
    end

    def invoices
      @invoices ||= StripeLocal::Invoice.where( customer_id: customer.id ).order( date: :desc )
    end

    def paid_invoices
      invoices.paid
    end

    def charges
      @charges ||= StripeLocal::Charge.where( customer_id: customer.id ).order( created: :desc )
    end

    def transactions
      @transactions ||= StripeLocal::Transaction.where( source: charges ).order( created: :desc )
    end

    def pending_transactions
      transactions.pending
    end

    def available_transactions
      transactions.available
    end
  end
end