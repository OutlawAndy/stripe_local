module StripeLocal
  class Transaction < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    time_writer :created, :available_on

    class<<self
      def create object
        super normalize( object )
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :source then :source_id
          when :type   then :source_type
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end
    end


  #=!=#>>>
  # string   :id
  # integer  :amount
  # datetime :available_on
  # datetime :created
  # integer  :fee
  # integer  :net
  # string   :source_id
  # string   :source_type
  # string   :status
  # string   :description
  #=¡=#>>>
  end
end