require 'spec_helper'

describe StripeLocal::Balance do

	before do
		StripeLocal::Balance.create pending: 29900, available:  9900
		StripeLocal::Balance.create pending: 19900, available: 19900
	end

	subject { StripeLocal::Balance }

	its( :current )  { should be 19900 }

	its( :previous ) { should be  9900 }

	its( :changed )  { should be 10000 }

	its( :pending )  { should be 19900 }

	its( :previous_pending ) { should be 29900 }

  describe "redundant `StripeLocal::balance.available` webhook is received" do
    before do
      @count = StripeLocal::Balance.count
      @updated = StripeLocal::Balance.last.updated_at.to_i
    end
    before { Timecop.travel 1.day.from_now }
    after  { Timecop.return }

    it "keeps StripeLocal::Balance updated, but doesn't create redundant records" do
      StripeLocal::Balance.event({ pending: 19900, available: 19900 })

      StripeLocal::Balance.count.should eq @count
      StripeLocal::Balance.last.updated_at.to_i.should > @updated
    end
  end

	describe "`balance.available` webhook signifies a changed balance" do
		before { @count = StripeLocal::Balance.count }

		it "creates a new record" do
			StripeLocal::Balance.event({ pending: 0, available: 39800 })

			StripeLocal::Balance.count.should eq @count + 1
		end
	end
end
