require 'spec_helper'


# describe StripeLocal::Customer do
#   let( :dummy ) { Client.create name: "John Appleseed", email: "jappseed@gmail.com", password: "password" }
#   let( :response ) { Load::Erb.stripe_response({ customer_id: "ABC-123", plan_id: "GIN150", interval: "month", amount: 14999 }) }
#
#   before do
#     Stripe.api_key = "9M1iTZf21gBPtf6B2fViF8gVsD1j7QHF"
#   end
#
#   it "decorates AR models that reference it with the macro 'stripe_customer'" do
#
#     dummy.stripe_customer_id = StripeLocal::Customer.signup( { plan: "HR99", card: "tok_2vIxcJTyoTl8TP" } )
#     dummy.account_balance.must_match 0
#   end
#
# end
