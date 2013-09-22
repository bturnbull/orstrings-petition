class ConfirmationSender
  attr_reader   :confirmation
  attr_accessor :message, :sent_at

  def initialize(confirmation, opts = {})
    @confirmation = confirmation
    self.sent_at  = opts[:sent_at]
    self.message  = opts[:message]
  end

  def sent_at
    @sent_at ||= Time.now
  end

  def message
    @message ||= ConfirmationMailer.confirmation(confirmation)
  end

  def deliver(deliverer = nil)
    unless confirmation.confirmed?
      message ||= self.message
      if message.deliver
        confirmation.update_attribute(:sent_at, sent_at)
      end
    end
  end

end
