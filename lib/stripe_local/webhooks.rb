StripeLocal::Webhook.subscribe do |event|
	Prowly.notify do |n|
    n.apikey = '2c6f33b43638a402c4c5b1872d4c974127971a5f'
    n.application = 'StripeLocal'
    n.event = event.type
    n.description = event
  end
end

StripeLocal::Webhook.setup do
	subscribe( 'charge.succeeded' )          { |event| StripeLocal::Charge.create         event.data.object }
	subscribe( 'charge.failed' )             { |event| StripeLocal::Charge.create         event.data.object }
	subscribe( 'invoice.created' )           { |event| StripeLocal::Invoice.create        event.data.object }
	subscribe( 'invoice.payment_succeeded' ) { |event| StripeLocal::Invoice.succeed       event.data.object }
	subscribe( 'invoice.payment_failed' )    { |event| StripeLocal::Invoice.fail          event.data.object }
	subscribe( 'plan.created' )              { |event| StripeLocal::Plan.create           event.data.object }
	subscribe( 'plan.deleted' )              { |event| StripeLocal::Plan.delete event.data.object.id, false }
	subscribe( 'coupon.created' )            { |event| event.data.object } #TODO: need to implement this
	subscribe( 'coupon.deleted' )            { |event| event.data.object } #TODO: need to implement this
end
