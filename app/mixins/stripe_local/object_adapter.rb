module StripeLocal
  module ObjectAdapter
    extend ActiveSupport::Concern

    module ClassMethods
      def find_remote id
        object = stripe_object.retrieve id
        new object
      end

      # read access to stripe object
      def stripe_object
        @stripe_object ||= Object.qualified_const_get "Stripe::#{self.to_s.classify}"
      end

      #=!=#
      # attr_accessor like <tt>macro</tt> for DateTime columns of a localized Stripe Object class
      # to use:
      #   * Pass in one or more symbolized column names.
      # Generates setter methods for converting JSON style `epoch` timestamps to the proper DateTime values your database expects.
      # +Note:+ Regular <tt>DateTime</tt> objects are perfectly acceptable as arguments because the value is always coerced into an <tt>Integer</tt> before conversion.
      #=¡=#
      def time_writer *array_of_syms
        array_of_syms.each do |sym|
          define_method ":#{sym}=" do |epoch|
            write_time sym, epoch.to_i
          end
        end
      end
    end

    def write_time sym, epoch
      write_attribute sym, Time.at( epoch ) if epoch > 0
    end

    included do
      private :write_time
    end

  end
end