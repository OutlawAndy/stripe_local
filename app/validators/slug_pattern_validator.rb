class SlugPatternValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
		if value.blank?
			record.errors[attribute] << "cannot be blank"
		else
			return string_replaced value
		end
  end

	def string_replaced value
		email_removal_for_morons value
		intelligently_de_dot value
		finish_normalizing value
		value
	end

private

	def finish_normalizing str
		str.gsub!(/\W/,'-')
		str.gsub!(/(\W\-|\-\W|\-)+/,'-')
		str.gsub!(/(\A\-|\-\Z)/,'')
		str
	end

	def intelligently_de_dot str
		str.gsub!(/([A-Z])\.([a-z])/,'\1-\2')
		str.gsub!(/([A-Z])\./,'\1')
		str
	end

	def email_removal_for_morons str
		str.gsub(/^(.*)?@([^@]*)?\.([^@\.]*)$/, '\1' )
		pattern = ("" == $1) ? '\2-\3' : '\1'
		str.gsub!(/^(.*)?@([^@]*)?\.([^@\.]*)$/, pattern )
		str
	end
end