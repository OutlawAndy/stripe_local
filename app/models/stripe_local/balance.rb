module StripeLocal
  class Balance < ActiveRecord::Base
    include ObjectAdapter

    @@cache ||= {}
    after_create do |record|
      @@cache = { current: record.available, pending: record.pending }
    end

    class<<self
      def available
        @@cache[:current] ||= all.pluck( :available ).last || 0
      end
      alias :current :available

      def pending
        @@cache[:pending] ||= all.pluck( :pending ).last || 0
      end

      def previous_available
        @@cache[:previous] ||= all.pluck( :available )[-2] || 0
      end
      alias :previous :previous_available

      def previous_pending
        @@cache[:previous_pending] ||= all.pluck( :pending )[-2] || 0
      end

      def changed
        @@cache[:changed] ||= ( self.current - self.previous )
      end

      def event update
        if ( self.pending == update[:pending] ) && ( self.available == update[:available] )
          Balance.last.touch
        else
          Balance.create( update )
        end
      end
    end

    def to_s
      Balance.available.to_money
    end
    alias :inspect :to_s
  end
#=!=#
# ==Database Schema
#
# integer  :available
# integer  :pending
#=¡=#
end