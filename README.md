# RailsCallbackLog

Logs callbacks to help with debugging. 

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
