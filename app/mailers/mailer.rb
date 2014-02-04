class Mailer < ActionMailer::Base
  raise 'Mail setting "from" not found.' unless Settings.mail.from?

  FRIENDLY_FROM = "Ruby Docs <#{Settings.mail.from}>"

  default from: FRIENDLY_FROM

  def doc_collection_generated(doc_collection, emails)
    @doc_collection = doc_collection

    mail \
      to:      FRIENDLY_FROM,
      bcc:     emails,
      subject: "[Ruby Docs] #{@doc_collection.name} docs are ready!"
  end
end
