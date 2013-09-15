class ApplicationController < ActionController::Base
  protect_from_forgery

  # The IP address of the remote end making this request
  def remote_ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end
end
