module StripeLocal
  class Discount < ActiveRecord::Base
    include ObjectAdapter

    time_writer :start, :end

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
          h[key] = v
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