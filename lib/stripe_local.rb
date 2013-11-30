require "stripe_local/engine"
require "stripe_local/webhook"
require "stripe_local/instance_delegation"
require "stripe_local/association_methods"


module StripeLocal
  mattr_accessor :model_class

  def stripe_customer
    include InstanceDelegation
    include AssociationMethods

    has_one :customer,  inverse_of:  :model,
                        foreign_key: :model_id,
                        class_name:  'StripeLocal::Customer'

    StripeLocal::model_class = self
  end
end

ActiveRecord::Base.extend StripeLocal