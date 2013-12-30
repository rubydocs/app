require 'activity_log'

module Services
  # Module that wraps calls to `call` and logs to activity log
  module LogCall
    def call(*args)
      log "START with args: #{args}"
      start = Time.now
      begin
        result = super
      rescue StandardError => e
        log "#{e.class}: #{e.message}"
        e.backtrace.each do |line|
          log line
        end
        raise e
      end
    ensure
      log "END after #{(Time.now - start).round(2)} seconds"
      result
    end
  end

  class Base
    class << self
      def inherited(subclass)
        subclass.send :include, Asyncable
        subclass.send :prepend, LogCall
        subclass.const_set :Error, Class.new(StandardError)
      end

      delegate :call, to: :new
    end

    def initialize
      @id = SecureRandom.hex(6)
      @logger = ::ActivityLog.new
    end

    def call
      raise NotImplementedError
    end

    private

    def log(message, severity = :info)
      @logger.log [self.class, @id], message, severity
    end
  end
end
