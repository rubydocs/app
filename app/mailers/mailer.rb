class Mailer < ActionMailer::Base
  FROM = "RubyDocs <#{ENV.fetch('MAIL_FROM')}>"

  default from: FROM

  def doc_collection_generated(doc_collection, emails)
    @doc_collection = doc_collection

    mail \
      to:      FROM,
      bcc:     emails,
      subject: "[RubyDocs] #{@doc_collection.name} docs are ready!"
  end

  def doc_collection_checks(messages)
    mail \
      to:      ENV.fetch('MAIL_ADMIN'),
      subject: "[RubyDocs] Data collection checks",
      body:    messages.join("\n")
  end
end
