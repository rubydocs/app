require 'addressable/uri'
require 'rest-client'

module Cloudflare
  BASE_URL = 'https://api.cloudflare.com/client/v4/'

  Error = Class.new(StandardError)

  extend self

  def kv_store(key, value)
    path = "accounts/#{Settings.cloudflare.account_id}/storage/kv/namespaces/#{Settings.cloudflare.namespace_id}/values/#{key}"
    request path, value
  end

  def update_worker_script
    path    = "zones/#{Settings.cloudflare.zone_id}/workers/script"
    payload = File.read(Rails.root.join('lib', 'cloudflare_worker.js'))
    request path, payload, headers: { content_type: 'application/javascript' }
  end

  private

  def request(path, payload, method: :put, headers: {})
    params = {
      method:  method,
      url:     Addressable::URI.join(BASE_URL, path).to_s,
      payload: payload,
      headers: {
        'X-Auth-Email': Settings.cloudflare.email,
        'X-Auth-Key':   Settings.cloudflare.auth_key
      }.merge(headers)
    }
    10.tries on: [RestClient::GatewayTimeout, RestClient::ServiceUnavailable] do
      RestClient::Request.execute(params)
    end
  end
end
