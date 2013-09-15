
class ConfirmationsController < ApplicationController

  def show
    @conf = Confirmation.where(:token => params[:id]).first

    if @conf
      # Update the confirmation record and associated signature if they
      # have not already been confirmed.
      unless @conf.confirmed?
        @conf.confirmed_at = Time.now
        @conf.ip = remote_ip
        @conf.save
        unless @conf.signature.confirmed?
          @conf.signature.update_attribute(:confirmed_at, @conf.confirmed_at)
        end
      end

      redirect_to petition_signature_url(@conf.signature)
    else
      # render confirmation token error
    end
  end

end
