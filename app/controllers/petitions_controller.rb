class PetitionsController
  def show
    @petitioners = Petitioner.signed
  end
end
