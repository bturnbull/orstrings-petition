class InboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! Rails.configuration.mandrill[:inbound][:apikey]

  def handle_inbound(event_payload)
    InboundMailEvent.new(event_payload).process
  end
end
