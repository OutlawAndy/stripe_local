class StateAbbreviationValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
		unless value.blank?
			if value.size > 2
				value = STATES_HASH.fetch( value.downcase, 'invalid' )
				record[attribute] = value
			end
	    unless value.in? STATES_HASH.values
	      record.errors[attribute] << "not a state of this great nation"
	    end
		end
  end
end