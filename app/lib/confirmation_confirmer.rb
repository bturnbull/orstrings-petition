class ConfirmationConfirmer
  attr_accessor :ip, :confirmation, :confirmed_at

  def initialize(opts = {})
    self.ip           = opts[:ip]
    self.confirmation = opts[:confirmation]
    self.confirmed_at = opts[:confirmed_at]
  end

  def confirmed_at
    @confirmed_at ||= Time.now
  end

  def confirm
    unless confirmation.confirmed?
      confirmation.ip           ||= ip
      confirmation.confirmed_at ||= confirmed_at
      if confirmation.save
        signature = confirmation.signature
        signature.update_attribute(:confirmed_at, confirmed_at)
      end
    end
  end

end
