class InvitesController < ApplicationController

  def show
    @invite = Invite.where(:token => params[:id])

    if @invite
      ## TODO - Set session data
      redirect_to new_petition_signature_url
    else
      ## render invalid token page
    end
  end

end
