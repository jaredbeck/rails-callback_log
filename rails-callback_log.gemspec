# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_callback_log/version"

::Gem::Specification.new do |spec|
  spec.name = "rails-callback_log"
  spec.version = ::RailsCallbackLog::VERSION
  spec.authors = ["Jared Beck"]
  spec.email = ["jared@jaredbeck.com"]
  spec.summary = "Logs callbacks to help with debugging."
  spec.homepage = "https://github.com/jaredbeck/rails-callback_log"
  spec.license = "MIT"
  spec.files = [
    "Gemfile", # necessary?
    "LICENSE.txt", # because: lawyers
    "lib/rails-callback_log.rb",
    "lib/rails_callback_log/version.rb",
    "rails-callback_log.gemspec"
  ]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0"
  spec.add_runtime_dependency "activesupport", [">= 4.2.0", "< 5.2"]
  spec.add_development_dependency "appraisal", "~> 2.2"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
