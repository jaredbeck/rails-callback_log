require "rails_callback_log/version"

# We expect `ActiveSupport::Callbacks::Callback#make_lambda` to be defined before we
# continue, because we are going to overwrite it.
require "active_support/all"

module RailsCallbackLog
  # Filtering is very expensive. It makes my test suite more than 50%
  # slower. So, it's off by default.
  FILTER = ENV["RAILS_CALLBACK_LOG_FILTER"].present?.freeze

  class << self
    def matches_filter?(str)
      source_location_filters.any? { |f| str.start_with?(f) }
    end

    private

    def source_location_filters
      @@filters ||= %w(app lib).map { |dir| (::Rails.root + dir).to_s }
    end
  end

  module CallbackExtension
    # Return a lambda that wraps `ActiveSupport::Callbacks::Callback#make_lambda`,
    # adding logging.
    def make_lambda(filter)
      original_lambda = super(filter)
      lambda { |*args, &block|
        if !::RailsCallbackLog::FILTER ||
          caller.any? { |line| ::RailsCallbackLog.matches_filter?(line) }
          ::Rails.logger.debug(format("Callback: %s", filter))
        end
        original_lambda.call(*args, &block)
      }
    end
  end
end

module ActiveSupport
  module Callbacks
    class Callback
      prepend ::RailsCallbackLog::CallbackExtension
    end
  end
end
