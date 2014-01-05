if Rails.env.production?
  %i(port server login password domain).each do |setting|
    raise %(Mail setting "#{setting}" not found.) unless Settings.mail.send("#{setting}?")
  end
  ActionMailer::Base.smtp_settings = {
    port:           Settings.mail.port,
    address:        Settings.mail.server,
    user_name:      Settings.mail.login,
    password:       Settings.mail.password,
    domain:         Settings.mail.domain,
    authentication: :plain
  }
  ActionMailer::Base.delivery_method = :smtp
end
