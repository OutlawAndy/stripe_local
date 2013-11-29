module StripeLocal
  class Plan < ActiveRecord::Base
    include SyncPlans

    self.primary_key = :id

    has_many :subscriptions, inverse_of: :plan
    has_many :members, through: :subscriptions,
                    inverse_of: :plan,
                        source: :customer

    class<<self
      def create object
        if found = find_by( id: object[:id] )
          found.update_attributes synced: true
        else
          super normalize object
        end
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :livemode then h[:synced] = true and next
          when ->(x){ attribute_method? x } then k.to_sym
          else next
          end
          h[key] = v
        end
      end
    end

  #=!=#>>>
  # string   :id
  # string   :name
  # integer  :amount
  # string   :interval
  # integer  :interval_count
  # integer  :trial_period_days
  # string   :currency
  # boolean  :synced
  #=¡=#>>>
  end
end