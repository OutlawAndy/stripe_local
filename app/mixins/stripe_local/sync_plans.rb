module StripeLocal
  module SyncPlans
    extend ActiveSupport::Concern

    included do
      after_create  :synchronize_create

      private :synchronize_create, :synchronize_destroy
    end

    module ClassMethods

      def delete id, destroy_remote = true
        if super( id )
          synchronize_destroy( id ) if destroy_remote == true
        end
      end
    end

    def synchronize_create
      hash = self.attributes
      unless !!hash.delete :synced
        Stripe::Plan.create hash #TODO: handle asynchronously
      end
    end

    def synchronize_destroy id
      begin
        Stripe::Plan.delete id
      rescue Stripe::Error
      end
    end

    def api_destroy plan
      Plan.destroy
    end

  end
end