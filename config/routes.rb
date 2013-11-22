StripeLocal::Engine.routes.draw do
  resources :charges

  resources :line_items

  resources :invoices

  resources :subscriptions

  resources :discounts

  resources :coupons

  resources :plans

  resources :cards

  resources :customers

	post 'webhook/events', to: 'webhooks#events'

end
