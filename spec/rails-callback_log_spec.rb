require "spec_helper"

module ActiveSupport
  module Callbacks
    if ::ActiveSupport.gem_version >= ::Gem::Version.new("5.1.0")
      RSpec.describe CallTemplate do
        describe "#make_lambda" do
          it "returns a Proc that calls the rails logger" do
            callback = double("mock callback")
            cb = described_class.build(:banana, callback)

            # Expect `make_lambda` to return a `Proc`.
            lambda_with_log = cb.make_lambda
            expect(lambda_with_log).to be_a(::Proc)

            # Mock the rails logger. We're going to expect it to receive a `debug` message.
            logger = double
            allow(logger).to receive(:debug)
            allow(::RailsCallbackLog).to receive(:logger).and_return(logger)
            target = double

            # Symbol-based callbacks have a `target` and a `value`. The definition of
            # these arguments is not clear to me yet. My guess is an AR callback's `target`
            # would be a model instance, for example.
            allow(target).to receive(:kiwi).with(:banana)
            allow(target).to receive(:banana)

            # Call our lambda and expect it to send a debug message to our mock logger.
            lambda_with_log.call(target, :kiwi)
            expect(logger).to have_received(:debug).once.with("Callback: banana")
            expect(target).to have_received(:banana).once
          end
        end
      end
    else
      RSpec.describe Callback do
        describe "#make_lambda" do
          it "returns a Proc that calls the rails logger" do
            # Instantiate a `Callback`. For this test, none of the arguments matter.
            name = double.as_null_object
            filter = double.as_null_object
            kind = double.as_null_object
            options = double.as_null_object
            chain_config = double.as_null_object
            cb = described_class.new(name, filter, kind, options, chain_config)

            # Expect `make_lambda` to return a `Proc`.
            lambda_with_log = cb.make_lambda(:banana)
            expect(lambda_with_log).to be_a(::Proc)

            # Mock the rails logger. We're going to expect it to receive a `debug` message.
            logger = double
            allow(logger).to receive(:debug)
            allow(::Rails).to receive(:logger).and_return(logger)
            target = double

            # Symbol-based callbacks have a `target` and a `value`. The definition of
            # these arguments is not clear to me yet. My guess is an AR callback's `target`
            # would be a model instance, for example.
            allow(target).to receive(:kiwi).with(:banana)
            allow(target).to receive(:banana)

            # Call our lambda and expect it to send a debug message to our mock logger.
            lambda_with_log.call(target, :kiwi)
            expect(logger).to have_received(:debug).once.with("Callback: banana")
            expect(target).to have_received(:banana).once
          end
        end
      end
    end
  end
end
