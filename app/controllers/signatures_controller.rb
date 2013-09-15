class SignaturesController < ApplicationController

  def index
    @signatures = Signature.confirmed
  end

  def show
    @signature = Signature.find(params[:id])
  end

  def new
    @signature = Signature.new
  end

  def create
    @signature    = Signature.new(params[:signature])
    @signature.ip = remote_ip

    if @signature.save
      @signature.confirmations.create
      redirect_to petition_signature_url(@signature)
    else
      render :action => 'new'
    end
  end
end
