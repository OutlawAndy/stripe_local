class ZipTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
		unless value.blank?
			record[attribute] = value.to_i
			return value = value.to_i + 0
		end
  end
end
