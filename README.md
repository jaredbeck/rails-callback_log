# RailsCallbackLog

Do you have a rails app with a lot of callbacks? Are they kind of a mystery? Maybe logging them would help.

```
Started GET "/" for 127.0.0.1 at 2016-07-26 13:25:32 -0400
Processing by HomeController#index as HTML
Callback: verify_authenticity_token
Callback: activate_authlogic
Callback: require_client_subdomain
  Client Load (0.4ms)  SELECT  `clients`.* ...
Callback: check_hostname
Callback: update_last_request_at
...
```

## Installation

```ruby
# Gemfile
gem "rails-callback_log", group: [:development, :test]
```

Do not use this gem in production because it adds significant overhead.

## Filtering Output

Rails has a lot of its own callbacks that you probably don't care about. If you
don't want to log them, enable filtering.

```
# Enable filtering
export RAILS_CALLBACK_LOG_FILTER="make it so"

# Disable filtering
unset RAILS_CALLBACK_LOG_FILTER
```

Filtering incurs a serious performance penalty, so it is off by default.

## See Also

- http://stackoverflow.com/q/13089936/567762

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
