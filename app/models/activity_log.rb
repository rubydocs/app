class ActivityLog
  def initialize
    log_file = Rails.root.join('log', 'activity.log')
    @logger = ActiveSupport::TaggedLogging.new(Logger.new(log_file))
    # TODO: Does this actually work?
    # Remove existing tags (`Rails.application.config.log_tags`)
    @logger.clear_tags!
  end

  def log(tags, message, severity = :info)
    @logger.tagged Time.now, severity.upcase, *tags do
      @logger.send severity, message
    end
  end
end
