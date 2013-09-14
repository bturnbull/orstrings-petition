class PetitionsController < ApplicationController
  def show
    @petitioners = Petitioner.signed
    render 'petitioners/index'
  end
end
