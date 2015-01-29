class Mailer < ActionMailer::Base
  def doc_collection_generated(doc_collection, emails)
    @doc_collection = doc_collection

    friendly_from = "RubyDocs <#{Settings.mail.from}>"

    mail \
      from:    friendly_from,
      to:      friendly_from,
      bcc:     emails,
      subject: "[RubyDocs] #{@doc_collection.name} docs are ready!"
  end
end
