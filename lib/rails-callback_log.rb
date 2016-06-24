require "active_support/callbacks"
require "rails_callback_log/version"
require 'benchmark'

module RailsCallbackLog
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
          lambda { |*args|
            if caller.any? { |line| ::RailsCallbackLog.matches_filter?(line) }
              ::Rails.logger.debug(format("Callback: %s", filter))
            end
            original_lambda.call(*args)
          }
        end
        alias_method_chain :make_lambda, :log
      end
    end
  end
else
  warn "RailsCallbackLog does not support rails version: #{::Rails.gem_version}"
end
