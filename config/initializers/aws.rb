require 'aws'

AWS.config \
  logger:            Rails.logger,
  access_key_id:     Settings.aws.key,
  secret_access_key: Settings.aws.secret,
  region:            Settings.aws.region
