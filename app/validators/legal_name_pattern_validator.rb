class LegalNamePatternValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || !value.match(/\A\S+?\s\S+?(?:\s\S+?)?\Z/i)
      record.errors[attribute] << "must be in the form \"First Last\", \"First Middle Last\", or \"First M Last\" (no prefixes or suffixes)"
		end
  end
end