StripeLocal::Webhook.subscribe do |event|
	Prowly.notify do |n|
    n.apikey = '2c6f33b43638a402c4c5b1872d4c974127971a5f'
    n.application = 'Techcom HR Dashboard'
    n.event = event.type
    n.description = event
  end
end

StripeLocal::Webhook.setup do
	subscribe( 'charge.succeeded' )          { |event| StripeLocal::Charge.create      event.data.object }
	subscribe( 'charge.failed' )             { |event| StripeLocal::Charge.recover     event.data.object }
	subscribe( 'invoice.created' )           { |event| StripeLocal::Invoice.create     event.data.object }
	subscribe( 'invoice.payment_succeeded' ) { |event| StripeLocal::Invoice.succeed    event.data.object }
	subscribe( 'invoice.payment_failed' )    { |event| StripeLocal::Invoice.fail       event.data.object }
	subscribe( 'plan.created' )              { |event| StripeLocal::Plan.create_hook   event.data.object }
	subscribe( 'plan.deleted' )              { |event| StripeLocal::Plan.delete_hook   event.data.object }
	subscribe( 'coupon.created' )            { |event| StripeLocal::Coupon.create_hook event.data.object }
	subscribe( 'coupon.deleted' )            { |event| StripeLocal::Coupon.delete_hook event.data.object }
end
