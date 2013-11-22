require 'spec_helper'

describe StripeLocal::Card do
  let(:response) { File.read("./spec/webhook_fixtures/customer.created.json") }
  let(:stripe_customer) { Stripe::Customer.construct_from(MultiJson.load(response)) }

  it 'can normalize Stripe Params on creation' do
    card = StripeLocal::Card.create( stripe_customer.cards.data.first.to_hash )
    card.brand.should == 'Visa'
    card.name.should == 'Connor Tumbleson'
  end

end