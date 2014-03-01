# TODO: Remove this when time args are not passed automatically anymore
# https://github.com/tobiassvn/sidetiq/issues/37
module Sidetiq
  class Handler
    private

    def enqueue(worker, time, redis)
      key      = "sidetiq:#{worker.name}"
      time_f   = time.to_f
      next_run = (redis.get("#{key}:next") || -1).to_f

      if next_run < time_f
        info "Enqueue: #{worker.name} (at: #{time_f}) (last: #{next_run})"

        redis.mset("#{key}:last", next_run, "#{key}:next", time_f)

        worker.perform_at(time)
      end
    rescue StandardError => e
      handle_exception(e, context: "Sidetiq::Handler#enqueue")
      raise e
    end
  end
end
