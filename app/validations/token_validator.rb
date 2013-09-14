class TokenValidator < ActiveModel::EachValidator
  def validate_each(model, attr, value)
    unless value && value.match(/^[0-9a-f]{32}$/)
      model.errors[attr] << "invalid token"
    end
  end
end
