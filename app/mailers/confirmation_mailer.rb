class ConfirmationMailer < MailerBase

  # Mail to confirm a petiton signature.  TODO - template for mail body
  def confirmation(confirmation)
    unless confirmation.confirmed?
      mail :subject => "OR String Petition Signature Confirmation",
           :to      => confirmation.signature.email,
           :from    => "confirm@orstrings.org",
           :body    => "#{confirmation.signature.first_name} -- Please click this link to confirm your signature. #{petition_confirmation_url(confirmation)}"
    end
  end

end
