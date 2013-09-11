class InvitesController < ApplicationController
  def index
    @sender = Petitioner.find(params[:signer_id])
    @invites = @sender.invites.all
  end

  def show
    @sender = Petitioner.find(params[:signer_id])
    @invite = @sender.invites.find(params[:id])
  end

  def new
    @sender = Petitioner.find(params[:signer_id])
    @invite = @sender.invites.new
  end

  def create
    @sender = Petitioner.find(params[:signer_id])
    @recipient = Petitioner.create(:first_name => params[:invite][:first_name],
                                   :last_name  => params[:invite][:last_name],
                                   :email      => params[:invite][:email])
    @invite = @sender.invites.new(:recipient => @recipient)

    if @invite.save
      redirect_to petition_signer_invite_url(@sender, @invite)
    else
      render :action => 'new'
    end
  end
end
