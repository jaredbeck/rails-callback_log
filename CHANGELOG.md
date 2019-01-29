# Changelog

This gem conforms to [semver 2.0.0][1] and follows the recommendations of
[keepachangelog.com][2].

### Unreleased

Breaking Changes:

- None

Added:

- None

Fixed:

- None

### 0.3.0 (2019-01-29)

Breaking Changes:

- Drop `RailsCallbackLog::VERSION`, use `RailsCallbackLog.gem_version`

Added:

- Support rails 5.2

Fixed:

- [#5](https://github.com/jaredbeck/rails-callback_log/pull/5)
  Huge improvements to output in rails > 5.1

### 0.2.2 (2017-05-08)

Breaking Changes:

- None

Added:

- None

Fixed:

- [#3](https://github.com/jaredbeck/rails-callback_log/pull/3)
  Fallback to ::Logger if Rails::Logger not loaded

### 0.2.1 (2017-05-02)

Breaking Changes:

- None

Added:

- None

Fixed:

- Fix a performance issue introduced in 0.2.0

### 0.2.0 (2017-05-01)

Breaking Changes:

- None

Added:

- Support for rails 5.1

### 0.1.0 (2016-07-25)

Breaking changes:

- Drop support for ruby 1.9.3

Added:

- Support for rails 5.0

### 0.0.3 (2016-06-24)

Initial release, support for rails 4.2 only.

[1]: http://semver.org/
[2]: http://keepachangelog.com/
