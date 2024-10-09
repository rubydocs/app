# frozen_string_literal: true

require "sidekiq"

threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

port    ENV.fetch("PORT",    3000)
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

plugin :tmp_restart

# Recommendation from https://github.com/Shopify/autotuner
before_fork do
  3.times { GC.start }
  GC.compact
end

preload_app!

sidekiq = nil

on_worker_boot do
  Sidekiq.default_job_options = {
    "retry" => false
  }
  Sidekiq.strict_args!(:warn)
  sidekiq = Sidekiq.configure_embed do |config|
    config.concurrency = 1
    config.redis = {
      url: Baseline::RedisURL.fetch
    }
  end.tap(&:run)
end

on_worker_shutdown do
  sidekiq&.stop
end
