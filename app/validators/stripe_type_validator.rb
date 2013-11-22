class StripeTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || !value.in?( %w(individual corporation) )
      record.errors[attribute] << "must specify either individual or corporate"
		end
  end
end