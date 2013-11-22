require 'spec_helper'

describe StripeLocal::Transaction do
  let(:response) { File.read("./spec/webhook_fixtures/balance_transaction.json") }
  let(:transaction) { Stripe::StripeObject.construct_from(MultiJson.load(response)) }

  it "can normalize attributes from Stripe on create" do
    t = StripeLocal::Transaction.create( transaction )
    t.source_type.should eq "transfer"
    t.source_id.should eq "tr_2fOGfKABdHu3uf"
    t.status.should eq "available"
  end

end