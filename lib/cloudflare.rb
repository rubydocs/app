require 'addressable/uri'
require 'rest-client'

module Cloudflare
  BASE_URL = 'https://api.cloudflare.com/client/v4/'

  Error = Class.new(StandardError)

  extend self

  def kv_store(key, value)
    request kv_path(key), value
  end

  def kv_delete(key)
    request kv_path(key), nil, method: :delete
  end

  def update_worker_script
    path    = "zones/#{ENV.fetch('CLOUDFLARE_ZONE_ID')}/workers/script"
    payload = File.read(Rails.root.join('lib', 'cloudflare_worker.js'))
    request path, payload, headers: { content_type: 'application/javascript' }
  end

  private

    def kv_path(key)
      [
        'accounts',
        ENV.fetch('CLOUDFLARE_ACCOUNT_ID'),
        'storage',
        'kv',
        'namespaces',
        ENV.fetch('CLOUDFLARE_NAMESPACE_ID'),
        'values',
        key
      ].join('/')
    end

    def request(path, payload, method: :put, headers: {})
      params = {
        method:  method,
        url:     Addressable::URI.join(BASE_URL, path).to_s,
        payload: payload,
        headers: {
          'X-Auth-Email': ENV.fetch('CLOUDFLARE_EMAIL'),
          'X-Auth-Key':   ENV.fetch('CLOUDFLARE_AUTH_KEY')
        }.merge(headers)
      }
      10.tries delay: 1 do
        RestClient::Request.execute(params)
      end
    rescue => e
      raise Error, "Error calling Cloudflare: #{e.message}"
    end
end
