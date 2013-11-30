module StripeLocal
  class Coupon < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    time_writer :redeem_by


  #=!=#>>>
  # string   :id
  # integer  :percent_off
  # integer  :amount_off
  # string   :currency
  # string   :duration
  # datetime :redeem_by
  # integer  :max_redemptions
  # integer  :times_redeemed
  # integer  :duration_in_months
  # boolean  :synced
  #=¡=#>>>
  end
end