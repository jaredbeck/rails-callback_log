require "active_support/callbacks"

module ActiveSupportCallbackLog
  # The version number corresponds with that of ActiveSupport.
  # e.g. ASCL 4.2.x corresponds with AS 4.2.x.
  VERSION = "4.2.0"
end

module ActiveSupport
  module Callbacks
    class Callback
      def make_lambda_with_log(filter)
        original_lambda = make_lambda_without_log(filter)
        lambda { |*args|
          app_path = (::Rails.root + "app").to_s
          if caller.any? { |line| line.include?(app_path) }
            ::Rails.logger.debug(format("Woo Callback: %s", filter))
          end
          original_lambda.call(*args)
        }
      end
      alias_method_chain :make_lambda, :log
    end
  end
end
