module StripeLocal
  class Discount < ActiveRecord::Base
    include ObjectAdapter

    time_writer :start, :end

    belongs_to :customer, inverse_of: :discount
    belongs_to :coupon,   inverse_of: :discount

    class<<self
      def create object
        super normalize object
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :customer then :customer_id
          when :coupon   then h[:coupon_id] = v.id and next
          when ->(x){ attribute_method? x } then k.to_sym
          else next
          end
          if v.is_a?(Numeric) && v > 1000000000
            h[key] = Time.at( v )
          else
            h[key] = v
          end
        end
      end
    end

  #=!=#>>>
  # string   :coupon_id
  # string   :customer_id
  # datetime :start
  # datetime :end
  #=¡=#>>>
  end
end