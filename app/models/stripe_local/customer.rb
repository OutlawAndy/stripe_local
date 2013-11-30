module StripeLocal
  class Customer < ActiveRecord::Base
    include ObjectAdapter

    self.primary_key = :id

    belongs_to :model,    inverse_of:  :customer,
                          foreign_key: "model_id",
                          class_name:  "::#{StripeLocal::model_class}"

    has_many   :cards,    inverse_of: :customer,
                          class_name: 'StripeLocal::Card'

    has_many   :invoices, inverse_of: :customer,
                          class_name: 'StripeLocal::Invoice'

    has_many   :charges,  inverse_of: :customer,
                          class_name: 'StripeLocal::Charge'

    has_one    :subscription, inverse_of: :customer,
                              class_name: 'StripeLocal::Subscription'

    has_one    :plan, through: :subscription,
                   inverse_of: :members,
                       source: :plan,
                   class_name: 'StripeLocal::Card'

    class<<self

      def create params
        super normalize params
      end

      def normalize params
        params.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :cards        then create_each_card( v.data ) and next
          when :subscription then create_subscription( v )   and next
          when :metadata     then h[:metadata] = MultiJson.dump( v.to_hash ) and next
          when ->(x){attribute_method? x} then k.to_sym
          else next
          end
          h[key] = v
        end
      end

      def create_each_card ary
        ary.each do |card|
          StripeLocal::Card.create( card.to_hash )
        end
      end

      def create_subscription object
        StripeLocal::Subscription.create( object.to_hash ) unless object.nil?
      end
    end

    def metadata
      MultiJson.load read_attribute( :metadata ), symbolize_keys: true
    end

#=!=>>>
#       ~<Schema>~
#   t.string   :id
#   t.integer  :account_balance
#   t.string   :default_card
#   t.boolean  :delinquent
#   t.string   :description
#   t.string   :email
#   t.text     :metadata
#   t.integer  :model_id
#   t.timestamps

#=¡=>>>
  end
end
