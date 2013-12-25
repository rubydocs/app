class Mailer < ActionMailer::Base
  default from: Settings.mail.from

  def doc_collection_generated(doc_collection, emails)
    @doc_collection = doc_collection

    mail \
      to:      Settings.mail.from,
      bcc:     emails,
      subject: "[Ruby Docs] #{@doc_collection.name} docs are ready!"
  end
end
