module StripeLocal
  module SyncPlans
    extend ActiveSupport::Concern

    included do
      after_create  :synchronize_create
      after_destroy :synchronize_destroy

      private :synchronize_create, :synchronize_destroy
    end

    module ClassMethods
      def sync_create from_hash
        Stripe::Plan.create from_hash
      end

      def sync_delete id
        Stripe::Plan.retrieve( id ).delete
      end
    end


    def synced?
      !!self.synced
    end

    def synchronize_create
      attributes = {
        id: id,
        name: name,
        amount: amount,
        currency: 'usd',
        interval: interval,
        interval_count: interval_count,
        trial_period_days: 0
      }
      Plan.sync_create attributes unless synced?
    end

    def synchronize_destroy
      Plan.sync_delete id unless synced?
    end

  end
end