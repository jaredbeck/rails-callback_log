$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# When we load `rails-callback_log.rb`, it will want to know what version of rails we
# is loaded. We don't want to load all of rails just to run our tests, so we simply
# define `::Rails.gem_version`.
module Rails
  def self.gem_version
    ::ActiveSupport.gem_version
  end
end

require "rails-callback_log"
