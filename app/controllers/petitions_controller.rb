class PetitionsController < ApplicationController

  def show
    @signatures = Signature.confirmed
  end

end
