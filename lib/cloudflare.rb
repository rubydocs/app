require 'rest-client'

module Cloudflare
  def self.store(key, value)
    response = RestClient::Request.execute(
      method:  :put,
      url:     "https://api.cloudflare.com/client/v4/accounts/#{Settings.cloudflare.account_id}/storage/kv/namespaces/#{Settings.cloudflare.namespace_id}/values/#{key}",
      headers: {
        'X-Auth-Email': Settings.cloudflare.email,
        'X-Auth-Key':   Settings.cloudflare.auth_key
      },
      payload: value
    )
    unless response.code == 200 && JSON.load(response.body)['success']
      fail Error, 'Error storing value on Cloudflare' rescue Rollbar.error $!, key: key, value: value, response: response
    end
  end
end
