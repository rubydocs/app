require "postmark"

Postmark.api_token = Rails.application.env_credentials.postmark_api_token
