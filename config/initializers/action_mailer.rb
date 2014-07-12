ActionMailer::Base.smtp_settings = {
  :port           => Settings.mail.port,
  :address        => Settings.mail.address,
  :user_name      => Settings.mail.user_name,
  :password       => Settings.mail.password,
  :domain         => Settings.mail.domain,
  :authentication => Settings.mail.authentication
}
ActionMailer::Base.delivery_method = :smtp
