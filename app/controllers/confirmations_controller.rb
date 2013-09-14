
class ConfirmationsController < ApplicationController

  def show
    @conf = Confirmation.where(:token => params[:id]).first

    if @conf
      @signature = @conf.signature
      @signature.update_attribute(:confirmed_at, Time.now) unless @signature.confirmed?
      redirect_to petition_signature_url(@conf.signature)
    else
      # render confirmation token error
    end
  end

end
