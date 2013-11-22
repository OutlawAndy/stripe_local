require 'spec_helper'

describe StripeLocal::Subscription do
  let(:response) { File.read("./spec/webhook_fixtures/customer.subscription.created.json") }
  let(:subscription) { Stripe::StripeObject.construct_from(MultiJson.load(response)) }

  it "can normalize attributes from Stripe on create" do
    s = StripeLocal::Subscription.create( subscription )
    s.plan_id.should eq "HR99"
    s.customer_id.should eq "cus_2vIuZmAfWK89Yk"
    s.status.should eq "active"
  end

end