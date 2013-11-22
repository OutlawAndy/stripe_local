module StripeLocal
  class Charge < ActiveRecord::Base
    include ObjectAdapter

    belongs_to :card, inverse_of: :charges
    belongs_to :customer, inverse_of: :charges
    has_one :transaction, as: :source
    has_one :invoice, inverse_of: :charge

    self.primary_key = :id

    time_writer :created

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
          when :customer then :customer_id
          when :card then h[:card_id] = v.id and next
          when :invoice then :invoice_id
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
  # string   :card_id
  # string   :customer_id
  # string   :invoice_id
  # string   :transaction_id
  # integer  :amount
  # boolean  :captured
  # boolean  :refunded
  # boolean  :paid
  # datetime :created
  # string   :currency
  # integer  :amount_refunded
  # string   :description
  # string   :failure_code
  # string   :failure_message
  # text     :metadata
  #=¡=#>>>
  end
end