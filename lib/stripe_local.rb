require "stripe_local/engine"
require "stripe_local/webhook"

module StripeLocal

  mattr_accessor :model_class

  def stripe_customer
    StripeLocal::model_class = self
    belongs_to :customer, inverse_of: :model, foreign_key: :stripe_customer_id, class_name: 'StripeLocal::Customer'
    setup_delegate
    include InstanceMethods
  end

  module InstanceMethods

    # for argument details, see StripeLocal::Customer#signup definition
    def signup params
      stripe_customer_id = StripeLocal::Customer.signup(params)
      save
    end

  end

private
  def setup_delegate
    class_eval <<-DEF
      def method_missing method, *args, &block
        if self.customer && self.customer.respond_to?( method )
          self.customer.send method, *args, &block
        else
          super
        end
      end

      def respond_to_missing? method, include_private = false
        super unless self.customer && self.customer.respond_to?( method )
      end

      def respond_to? method, include_private = false
        super unless self.customer && self.customer.respond_to?( method )
      end
    DEF
  end

end

ActiveRecord::Base.extend StripeLocal