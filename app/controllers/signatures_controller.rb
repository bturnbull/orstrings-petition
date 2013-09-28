class SignaturesController < ApplicationController

  def index
    @signatures = Signature.confirmed
  end

  def show
    @signature = Signature.find(params[:id])
  end

  def new
    @signature = Signature.new(:is_visible => true, :can_email => true)
  end

  def create
    # If an email address is already in the database but that signature for that
    # email address has not been confirmed, update the record and send a new
    # confirmation.  If the signature is already confirmed, don't do anything.
    #
    # Otherwise, create a new signature
    if (@signature = Signature.find_by_email(params[:signature][:email]))
      if @signature.confirmed?
        flash[:warning] = {:front => 'Duplicate',
                           :text  => 'The petition has already been signed by this email address.'}
        redirect_to petition_url
        return
      elsif @signature.confirmations.count < 3
        @signature.update_attributes(params[:signature])
      else
        flash[:error] = {:front => 'Sorry',
                         :text  => "To prevent abuse, we limit signature confirmations to three per email address and this email has reached that limit.  Please email #{view_context.mail_to('orstrings@brianturnbull.com?subject=Problem%20Signing%20OR%20Strings%20Petition', 'orstrings@brianturnbull.com')} for assistance signing the petition.".html_safe}
        redirect_to petition_url
        return
      end
    else
      @signature = Signature.new(params[:signature])
    end

    @signature.ip = remote_ip

    if @signature.save
      # TODO - Create background processing option
      ConfirmationSender.new(@signature.confirmations.create).deliver
      redirect_to petition_signature_url(@signature)
    else
      flash.now[:error] = 'The highlighted fields are required to sign the petition.'
      render :action => 'new'
    end
  end
end
