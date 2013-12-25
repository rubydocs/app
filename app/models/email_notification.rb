class EmailNotification
  include ActiveModel::Model

  attr_accessor :email, :doc_collection_id

  validates :email, presence: true, format: { with: /.+@.+\..+/, allow_blank: true }
  validates :doc_collection_id, presence: true

  def self.by_doc_collection(doc_collection)
    emails = REDIS_CONNECTION_POOL.with do |redis|
      redis.smembers cache_key(doc_collection.id)
    end
    emails.map do |email|
      self.new email: email, doc_collection_id: doc_collection.id
    end
  end

  def save
    return false unless self.valid?
    REDIS_CONNECTION_POOL.with do |redis|
      redis.sadd self.class.cache_key(self.doc_collection_id), self.email
    end
  end

  private

  def self.cache_key(doc_collection_id)
    [
      'doc_collection_notifications',
      doc_collection_id
    ].join(':')
  end
end
