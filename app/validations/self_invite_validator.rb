class SelfInviteValidator < ActiveModel::EachValidator
  def validate_each(model, attr, value)
    if value && model.sender && value == model.sender
      model.errors[attr] << "can't invite themselves"
    end
  end
end
