class FullNamePatternValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || !value.squeeze(" ").strip.match(/\A\S+?\s\S+?\Z/i)
      record.errors[attribute] << "First & Last names separated by a space"
		end
  end
end