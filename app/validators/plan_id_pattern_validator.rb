class PlanIdPatternValidator < ActiveModel::EachValidator  
  def validate_each record, attribute, value
    if value.nil? || !value.match(/^(([\w\-]{0,62})?)$/i)
      record.errors[attribute] << "accepts alphanumeric characters, '-', and '_' only. no spaces"  
    end  
  end  
end