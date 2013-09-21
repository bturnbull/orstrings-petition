
class ConfirmationsController < ApplicationController

  def show
    @conf = Confirmation.where(:token => params[:id]).first

    if @conf
      ConfirmationConfirmer.new(:ip => remote_ip, :confirmation => @conf).confirm
      redirect_to petition_signature_url(@conf.signature)
    else
      # render confirmation token error
    end
  end

end
