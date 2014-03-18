class Mailer < ActionMailer::Base
  raise 'Mail setting "from" not found.' if Settings.mail? && !Settings.mail.from?

  FRIENDLY_FROM = "RubyDocs <#{Settings.mail.from}>"

  default from: FRIENDLY_FROM

  def doc_collection_generated(doc_collection, emails)
    @doc_collection = doc_collection

    mail \
      to:      FRIENDLY_FROM,
      bcc:     emails,
      subject: "[RubyDocs] #{@doc_collection.name} docs are ready!"
  end
end
