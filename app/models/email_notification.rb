class EmailNotification
  include ActiveModel::Model

  attr_accessor :email, :doc_collection_id

  validates :email, presence: true, format: { with: /.+@.+\..+/, allow_blank: true }
  validates :doc_collection_id, presence: true

  class << self
    def by_doc_collection(doc_collection)
      emails = Redis.current.smembers(cache_key(doc_collection.id))
      emails.map do |email|
        self.new email: email, doc_collection_id: doc_collection.id
      end
    end

    def delete(doc_collection)
      Redis.current.del cache_key(doc_collection.id)
    end
  end

  def save
    return false unless self.valid?
    Redis.current.sadd self.class.cache_key(self.doc_collection_id), self.email
  end

  private

    def self.cache_key(doc_collection_id)
      [
        'email_notifications',
        doc_collection_id
      ].join(':')
    end
end
