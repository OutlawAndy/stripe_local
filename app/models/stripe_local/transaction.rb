module StripeLocal
  class Transaction < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    time_writer :created, :available_on


    belongs_to :source, polymorphic: true

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
          if v.is_a?(Numeric) && v > 1000000000
            h[key] = Time.at( v )
          else
            h[key] = v
          end
        end
      end

      def pending
        where 'available_on < ?', Time.now
      end

      def available
        where 'available_on > ?', Time.now
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