require 'spec_helper'

describe StripeLocal::Plan do
  let(:response) { File.read("./spec/webhook_fixtures/plan.created.json") }
  let(:stripe_plan) { Stripe::Invoice.construct_from(MultiJson.load(response)) }

  it "normalizes a plan created in the stripe dashboard and saves it locally" do
    StripeLocal::Plan.should_not_receive :sync_create

    plan = StripeLocal::Plan.create( stripe_plan )
    plan.id.should eq "HR99"
    plan.amount.should eq 9900
    plan.synced?.should be_true
  end

  it "will remotely sync creation of a new plan" do
    StripeLocal::Plan.should_receive :sync_create

    plan = StripeLocal::Plan.create( id: "New_Plan", amount: 2999, interval: "month", name: "New Plan" )
    plan.id.should eq "New_Plan"
    plan.amount.should eq 2999
  end

  # context "existing plan" do
  #   before { Plan.create id: 'HR99', amount: 9900, synced: false }
  #   it "will mark an existing plan as 'synced' upon an incoming 'plan.created' hook" do
  #     Plan.should_not_receive :sync_create
  #
  #     plan = Plan.create( stripe_plan )
  #     plan.synced.should be_true
  #   end
  # end
end