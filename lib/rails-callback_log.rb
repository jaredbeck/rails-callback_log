require "active_support/callbacks"
require "rails_callback_log/version"

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
end

if ::Gem::Requirement.new("~> 4.2.0").satisfied_by?(::Rails.gem_version)
  module ActiveSupport
    module Callbacks
      class Callback
        def make_lambda_with_log(filter)
          original_lambda = make_lambda_without_log(filter)
          lambda { |*args, &block|
            if !::RailsCallbackLog::FILTER ||
                caller.any? { |line| ::RailsCallbackLog.matches_filter?(line) }
              ::Rails.logger.debug(format("Callback: %s", filter))
            end
            original_lambda.call(*args, &block)
          }
        end
        alias_method_chain :make_lambda, :log
      end
    end
  end
else
  warn(
    "RailsCallbackLog does not support rails #{::Rails.gem_version} but " \
      "contributions are welcome!"
  )
end
