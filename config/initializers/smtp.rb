#config.action_mailer.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address   => "smtp.mandrillapp.com",
  :port      => 25, # ports 587 and 2525 are also supported with STARTTLS
  :enable_starttls_auto => true, # detects and uses STARTTLS
  :user_name => ENV["MANDRILL_USERNAME"],
  :password  => ENV["MANDRILL_APIKEY"], # SMTP password is any valid API key
  :authentication => 'login', # Mandrill supports 'plain' or 'login'
  :domain => ENV['DOMAIN'], # your domain to identify your server when co
}

