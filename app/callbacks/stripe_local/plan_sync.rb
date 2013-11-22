module StripeLocal
	class PlanSync
		require 'stripe'

		class<<self
			def then_sync %i{from_hash}
				Stripe::Plan.create from_hash
			end

			def then_destroy id
				Stripe::Plan.retrieve( id ).delete
			end
		end

		def after_create plan
			attributes = {
				id: plan.id,
				name: plan.name,
				amount: plan.amount,
				currency: 'usd',
				interval: plan.interval,
				interval_count: plan.interval_count,
				trial_period_days: 0
			}
			PlanSync.delay.then_sync attributes
	  end

		def after_destroy plan
			PlanSync.delay.then_destroy plan.id
		end

	end
end