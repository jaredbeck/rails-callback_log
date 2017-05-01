require "rails_callback_log/version"

# Make sure `ActiveSupport::Callbacks` is loaded before we continue.
require "active_support/all"

module RailsCallbackLog
  # Filtering is very expensive. It makes my test suite more than 50%
  # slower. So, it's off by default.
  FILTER = ENV["RAILS_CALLBACK_LOG_FILTER"].present?.freeze

  class << self
    def assert_method_not_defined(klass, method)
      if klass.method_defined?(method.to_sym)
        $stderr.puts(
          format(
            "Unable to install rails-callback_log: method already exists: %s",
            method
          )
        )
        ::Kernel.exit(1)
      end
    end

    def matches_filter?(str)
      source_location_filters.any? { |f| str.start_with?(f) }
    end

    private

    def source_location_filters
      @@filters ||= %w(app lib).map { |dir| (::Rails.root + dir).to_s }
    end
  end

  module CallbackExtension
    def _rails_cb_log(caller, message)
      if !::RailsCallbackLog::FILTER ||
        caller.any? { |line| ::RailsCallbackLog.matches_filter?(line) }
        ::Rails.logger.debug(format("Callback: %s", message))
      end
    end

    if ::ActiveSupport.gem_version >= ::Gem::Version.new("5.1.0")
      # Returns a lambda that wraps `super`, adding logging.
      def make_lambda
        original_lambda = super
        lambda { |*args, &block|
          _rails_cb_log(caller, @method_name)
          original_lambda.call(*args, &block)
        }
      end
    else
      # Returns a lambda that wraps `super`, adding logging.
      def make_lambda(filter)
        original_lambda = super(filter)
        lambda { |*args, &block|
          _rails_cb_log(caller, filter)
          original_lambda.call(*args, &block)
        }
      end
    end
  end
end

# Install our `CallbackExtension` using module prepend.
module ActiveSupport
  module Callbacks
    # In rails 4.2 and 5.0, `make_lambda` is a method of `Callback`.
    # In rails 5.1, `make_lambda` is a method of `CallTemplate`.
    if ::ActiveSupport.gem_version >= ::Gem::Version.new("5.1.0")
      ::RailsCallbackLog.assert_method_not_defined(CallTemplate, :_rails_cb_log)
      class CallTemplate
        prepend ::RailsCallbackLog::CallbackExtension
      end
    else
      ::RailsCallbackLog.assert_method_not_defined(Callback, :_rails_cb_log)
      class Callback
        prepend ::RailsCallbackLog::CallbackExtension
      end
    end
  end
end
