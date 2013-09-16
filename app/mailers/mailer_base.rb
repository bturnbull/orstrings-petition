class MailerBase < ActionMailer::Base

  class Exception < ::Exception; end

  if Orstrings::Application.config.action_mailer.smtp_settings.nil?
    raise Exception, "Missing smtp_settings - config/mandrill.yml absent?"
  else
    default_url_options[:host] = Orstrings::Application.config.action_mailer.smtp_settings[:domain]
  end

end
