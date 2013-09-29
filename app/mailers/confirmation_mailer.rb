class ConfirmationMailer < MailerBase

  # Mail to confirm a petiton signature.  TODO - template for mail body
  def confirmation(confirmation)
    @confirmation = confirmation
    unless @confirmation.confirmed?
      mail(:subject => "OR Strings Petition Signature Confirmation",
           :to      => @confirmation.signature.email,
           :from    => "OR Strings Petition <confirm@orstrings.org>")
    end
  end

end
