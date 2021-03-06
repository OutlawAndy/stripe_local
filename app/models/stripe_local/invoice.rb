module StripeLocal
  class Invoice < ActiveRecord::Base
    include ObjectAdapter

    has_many :lines,  inverse_of: :invoice, class_name: "LineItem"
    belongs_to :charge, inverse_of: :invoice
    belongs_to :customer, inverse_of: :invoices

    self.primary_key = :id

    time_writer :date, :period_start, :period_end, :next_payment_attempt

    class<<self
      def create object
        super normalize( object )
      end

      def normalize attrs
        attrs.each_with_object({}) do |(k,v),h|
          key = case k.to_sym
          when :customer then :customer_id
          when :charge   then :charge_id
          when :lines    then v.data.each do |item|
              StripeLocal::LineItem.create item.to_hash.merge({invoice_id: attrs.id})
            end and next
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

      def succeed inv
        find( inv.id ).update_attributes closed: true, paid: true, next_payment_attempt: nil
      end

      def fail inv
        find( inv.id ).update_attributes paid: false
      end

      def paid
        where paid: true
      end

      def unpaid
        where paid: false
      end
      alias :failed :unpaid
    end


  end
#=!=#
# ==Database Schema
#
# string   :id
# string   :customer_id
# integer  :amount_due
# integer  :subtotal
# integer  :total
# boolean  :attempted
# integer  :attempt_count
# boolean  :paid
# boolean  :closed
# datetime :date
# datetime :period_start
# datetime :period_end
# string   :currency
# integer  :starting_balance
# integer  :ending_balance
# string   :charge_id
# integer  :discount
# datetime :next_payment_attempt
#=¡=#
end