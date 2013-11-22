module StripeLocal
  class Subscription < ActiveRecord::Base
    include ObjectAdapter

    belongs_to :customer, inverse_of:  :subscription

    belongs_to :plan,     inverse_of:  :subscription

    time_writer :start, :canceled_at, :current_period_start,
                :current_period_end, :trial_start, :trial_end, :ended_at


    class<<self
      def create object
        super normalize( object )
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :id then next
          when :customer then :customer_id
          when :plan then h[:plan_id] = v.id and next
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end
    end


  #=!=#>>>
  # string   :customer_id
  # string   :plan_id
  # string   :status
  # datetime :start
  # datetime :canceled_at
  # datetime :ended_at
  # datetime :current_period_start
  # datetime :current_period_end
  # datetime :trial_start
  # datetime :trial_end
  #=¡=#>>>
  end
end