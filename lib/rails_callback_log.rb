require "active_support/callbacks"

module RailsCallbackLog
  SOURCE_LOCATION_FILTERS = %w(app lib).map { |dir| (::Rails.root + dir).to_s }.freeze
  VERSION = "0.0.1"

  def self.matches_filter?(str)
    SOURCE_LOCATION_FILTERS.any? { |f| str.start_with?(f) }
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
              ::Rails.logger.debug(format("Woo Callback: %s", filter))
            end
            original_lambda.call(*args)
          }
        end
        alias_method_chain :make_lambda, :log
      end
    end
  end
else
  warn "ActiveSupportCallbackLog does not support rails version: #{::Rails.gem_version}"
end
