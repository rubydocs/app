module Asyncable
  extend ActiveSupport::Concern

  # The name of the parameter that is added to the parameter list when calling a method to be processed in the background.
  TARGET_PARAM_NAME = :async_target_id

  included do
    include Sidekiq::Worker
  end

  %w(perform_async perform_in).each do |method_name|
    define_method method_name do |*args|
      self.class.send method_name, *args, TARGET_PARAM_NAME => self.id
    end
  end
  alias_method :perform_at, :perform_in

  def perform(*args)
    target = if args.last.is_a?(Hash) && args.last.keys.first.to_sym == TARGET_PARAM_NAME
      self.class.find args.pop.values.first
    else
      self.class
    end

    # Add :call as first argument if not present and target is a service
    # Sidetiq simply calls `perform` without arguments
    args = args.dup.unshift(:call) if target.is_a?(Class) && target < Services::Base && (args.empty? || args.first.to_sym != :call)

    target.send *args
  end
end
