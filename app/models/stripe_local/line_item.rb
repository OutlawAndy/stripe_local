module StripeLocal
  class LineItem < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    belongs_to  :invoice, inverse_of: :lines

    belongs_to  :plan, inverse_of: :line_items

    time_writer :period_start, :period_end

    def metadata= hash
      MultiJson.dump hash
    end

    def metadata
      MultiJson.load read_attribute( :metadata ), symbolize_keys: true
    end

    class<<self
      def create attr_hash
        super normalize( attr_hash )
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :invoice  then :invoice_id
          when :plan     then h[:plan_id] = v.id and next
          when :type     then h[:subscription] = (v == "subscription" ? true : false) and next
          when :period   then h[:period_start] = Time.at(v.start) and h[:period_end] = Time.at(v.end) and next
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end
    end

  #=!=#>>>
  # string   :id
  # string   :invoice_id
  # boolean  :subscription
  # integer  :amount
  # string   :currency
  # boolean  :proration
  # datetime :period_start
  # datetime :period_end
  # integer  :quantity
  # string   :plan_id
  # string   :description
  # text     :metadata
  #=¡=#>>>
  end
end