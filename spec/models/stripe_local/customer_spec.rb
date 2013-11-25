require 'spec_helper'


describe StripeLocal::Customer do
  let(:response) { File.read("./spec/webhook_fixtures/customer_creation_response.json") }
  let(:stripe_customer) { Stripe::StripeObject.construct_from(MultiJson.load(response)) }
  let(:client) { ::Client.create( name: "Test Case", email: "test@test.com", password: "password" ) }

  it "can normalize a customer on create" do
    Stripe::Customer.should_receive( :create ).and_return stripe_customer
    stripe_customer.should_receive :update_subscription
    StripeLocal::Customer.should_receive( :create ).with( stripe_customer ).and_call_original
    StripeLocal::Customer.should_receive( :normalize ).with( stripe_customer ).and_call_original
    client.signup( card: "token", plan: "plan" )
  end

end
