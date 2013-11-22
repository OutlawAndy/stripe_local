module StripeLocal
  class Transfer < ActiveRecord::Base
    include ObjectAdapter

    has_one :transaction, as: :source

    self.primary_key = :id

    time_writer :date

    def metadata= hash
      MultiJson.dump hash
    end

    def metadata
      MultiJson.load read_attribute( :metadata ), symbolize_keys: true
    end

    class<<self
      def create object
        super normalize( object )
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :balance_transaction then :transaction_id
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
  # datetime :date
  # string   :status
  # string   :transaction_id
  # string   :description
  # text     :metadata
  #=¡=#>>>
  end
end