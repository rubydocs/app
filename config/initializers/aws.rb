Aws.config.update \
  credentials: Aws::Credentials.new(Settings.aws.key, Settings.aws.secret),
  logger:      Rails.logger,
  region:      Settings.aws.region
