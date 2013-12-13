module StripeLocal
	class WebhooksController < ApplicationController
    def events
			begin
				_event_ = Stripe::Event.retrieve params[:id]
		    Webhook.publish _event_
		    head :ok
		  rescue Stripe::StripeError
		    head :unauthorized
			end
    end
	end
end