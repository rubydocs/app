class Mailer < ActionMailer::Base
  default \
    from: "RubyDocs <#{Settings.mail.from}>",
    to:   Settings.mail.to

  def doc_collection_generated(doc_collection, emails)
    @doc_collection = doc_collection

    mail \
      bcc:     emails,
      subject: "[RubyDocs] #{@doc_collection.name} docs are ready!"
  end
end
