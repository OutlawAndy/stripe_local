class PhonePatternValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
		if !value.blank?
			first_normalize value
	    unless value.match(/^((\d){10})$/i)
	      record.errors[attribute] << "10 digit phone number, area-code first, no country code please."
	    end
		end
  end

private

	def first_normalize number
		number.to_phone
	end

end