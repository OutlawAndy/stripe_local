require 'spec_helper'

describe StripeLocal::Charge do
  let(:response) { File.read("./spec/webhook_fixtures/charge.succeeded.json") }
  let(:stripe_charge) { Stripe::StripeObject.construct_from(MultiJson.load(response)) }

  it "can normalize a json webhook on create" do
    c = StripeLocal::Charge.create( stripe_charge.to_hash )
    c.card_id.should eq "cc_1eX7GyRo6wivEf"
    c.amount.should eq 9900
    c.captured.should be_true
  end
end