require 'spec_helper'

describe StripeLocal::Invoice do
  let(:response) { File.read("./spec/webhook_fixtures/invoice.payment_succeeded.json") }
  let(:stripe_invoice) { Stripe::Invoice.construct_from(MultiJson.load(response)) }

  it "can normalize Stripe Params on create" do
    i = StripeLocal::Invoice.create( stripe_invoice )
    i.customer_id.should eq "cus_1A3zUmx7NpUgrT"
    i.amount_due.should eq 9900
    i.total.should eq 9900
    i.subtotal.should eq 9900
    i.lines(true).size.should be 1
    i.lines.first.amount.should eq 9900
    i.lines.first.period_start.should eq "2013-05-07 18:23:47 -0500"
  end
end