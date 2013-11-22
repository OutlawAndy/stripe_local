Rails.application.routes.draw do

  mount StripeLocal::Engine => "/stripe_local"
end
