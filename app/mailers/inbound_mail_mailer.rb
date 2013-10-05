class InboundMailMailer < MailerBase

  # Mail to confirm a petiton signature.  TODO - template for mail body
  def inbound_mail(payload)
    @to_email = payload['msg']['email']
    @from_email = payload['msg']['from_email']
    @from_name = payload['msg']['from_name']
    @subject = payload['msg']['subject']
    @message = payload['msg']['text']
    attachments['raw_message.txt'] = payload['msg']['raw_msg']
    mail(:subject => "OR Strings Inbound Email: #{payload['msg']['from_email']}",
         :to      => Rails.configuration.mandrill[:inbound][:deliver_to],
         :from    => Rails.configuration.mandrill[:inbound][:deliver_from])
  end

end
