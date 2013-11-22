require "stripe"
require_relative "./webhook/subscriber"
require_relative "./webhook/types"

module StripeLocal

	#
	# basically taken straight from the StripeEvents gem
	# https://github.com/integrallis/stripe_event
	#
	#
	module Webhook
	  class << self
	    alias :setup :instance_eval

		  def publish event_obj
		    ActiveSupport::Notifications.instrument event_obj.type, event: event_obj
		  end

		  def subscribe *names, &block
		    Subscriber.new(*names, &block).register
		  end

		  def subscribers name
		    ActiveSupport::Notifications.notifier.listeners_for name
		  end

		  def clear_subscribers!
		    TYPE_LIST.each do |type|
		      subscribers(type).each { |s| unsubscribe(s) }
		    end
		  end

		  def unsubscribe subscriber
		    ActiveSupport::Notifications.notifier.unsubscribe subscriber
		  end

			def translate object, action, event
				klass = object.camelize.constantize
				klass.send action, event
			end

			def dispatch event
				object,action,sub_action = event.type.split('.')
				unless sub_action.nil?
					object = [object,action].join('_')
					action = sub_action
				end
				translate object, action, event
			end
		end
	end
end

require_relative "./webhooks"