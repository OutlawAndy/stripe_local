require "stripe_local/engine"
require "stripe_local/webhook"

module StripeLocal

	def stripe_customer
		belongs_to :customer, inverse_of: :model, foreign_key: :stripe_customer_id, class_name: 'StripeLocal::Customer'
		setup_delegate
		include InstanceMethods
	end

	module InstanceMethods

		def create_customer token, plan, coupon = nil, line_items = []
			c = Hash(card: token, plan: plan, coupon: coupon)
			cust = StripeLocal::Customer.signup(c,line_items)

		end

	end

private
	def setup_delegate
		class_eval <<-DEF
			def method_missing name, *args, &block
				if self.customer && self.customer.respond_to?( method )
					self.customer.send name, *args, &block
				else
					super
				end
			end

			def respond_to_missing? method, include_private = false
				super unless self.customer && self.customer.respond_to?( method )
			end

			def respond_to? method, include_private = false
				super unless self.customer && self.customer.respond_to?( method )
			end
		DEF
	end

end

ActiveRecord::Base.extend StripeLocal