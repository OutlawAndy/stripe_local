module StripeLocal
  class Card < ActiveRecord::Base
    primary_key = :id

    has_many   :charges,  inverse_of:  :card
    belongs_to :customer, inverse_of:  :cards,
                          primary_key: :customer_id,
                          foreign_key: :customer_id,
                          class_name:  "Member"


    class<<self
      def create attrs_hash
        super normalize( attrs_hash )
      end

      def normalize hash
        hash.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :customer then :customer_id
          when :type then :brand
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end
    end

  # =!=#>>>
  # string   :id
  # string   :customer_id
  # string   :name
  # integer  :exp_month
  # integer  :exp_year
  # string   :brand
  # string   :last4
  # string   :cvc_check
  # string   :fingerprint
  # =¡=#>>>
  end

end