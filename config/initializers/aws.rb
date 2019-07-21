Aws.config.update \
  credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID'), ENV.fetch('AWS_SECRET_ACCESS_KEY')),
  logger:      Rails.logger,
  region:      ENV.fetch('AWS_REGION')
