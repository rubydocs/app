class ApplicationMailer < ActionMailer::Base
  default \
    from:           "RubyDocs <hello@rubydocs.org>",
    template_path:  "mailers",
    message_stream: :outbound

  layout "mailer"
end
