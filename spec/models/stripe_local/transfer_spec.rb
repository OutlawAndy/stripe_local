require 'spec_helper'

describe StripeLocal::Transfer do
  let(:response) { File.read("./spec/webhook_fixtures/transfer.json") }
  let(:transfer) { Stripe::StripeObject.construct_from(MultiJson.load(response)) }

  it "can normalize a stripe transfer on create" do
    t = StripeLocal::Transfer.create( transfer )
    t.status.should eq "paid"
    t.amount.should eq 100
    t.id.should eq "tr_2fOGfKABdHu3uf"
  end
end