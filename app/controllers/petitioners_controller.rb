class PetitionersController < ApplicationController
  def index
    @petitioners = Petitioner.signed
  end

  def show
    @petitioner = Petitioner.find(params[:id])
  end

  def new
    @petitioner = Petitioner.new
  end

  def create
    @petitioner = Petitioner.new(params[:petitioner])

    if @petitioner.save
      redirect_to petition_signer_url(@petitioner)
    else
      render :action => 'new'
    end
  end
end
