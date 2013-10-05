class InboundMailEvent
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def process
    InboundMailMailer.inbound_mail(payload).deliver
  end
end
