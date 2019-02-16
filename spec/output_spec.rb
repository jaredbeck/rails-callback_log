require "spec_helper"

class CallbackWrapper
  def after(record)
    Rails.logger.info("- in CallbackWrapper after method")
  end
end

class CallbackTester
  include ActiveSupport::Callbacks
  define_callbacks :save

  def save
    run_callbacks :save do
      Rails.logger.info("- save")
    end
  end

  # Set a proc based callback
  set_callback :save, :before do
    Rails.logger.info("- in before save callback")
  end

  # Set an object based callback, will call `after` on CallbackWrapper
  set_callback :save, :after, CallbackWrapper.new

  # Set a symbol based method reference callback
  set_callback :save, :around, :around_callback
  def around_callback
    Rails.logger.info("- in around callback before")
    yield
    Rails.logger.info("- in around callback after")
  end
end

describe RailsCallbackLog do
  # Filter the logs down to only the lines that start with Callback. Makes the
  # test output easier to read.
  subject(:filtered_log) do
    output.string.split("\n").select { |line| line =~ /^Callback/ }.join("\n")
  end

  # Create a logger that logs to a StringIO that we can test against
  let(:output) { StringIO.new }
  let(:logger) do
    logger = Logger.new(output)
    logger.formatter = proc { |severity, datetime, progname, msg|
      "#{msg}\n"
    }
    logger
  end

  before do
    # Set the logger to our custom StringIO logger
    Rails.logger = logger
  end

  describe ".log" do
    it "logs all of the callbacks" do
      CallbackTester.new.save

      expect(filtered_log).to include "Callback: #<Proc:"
      expect(filtered_log).to include "Callback: :around_callback"
      expect(filtered_log).to include "Callback: #<CallbackWrapper:"
    end
  end
end
