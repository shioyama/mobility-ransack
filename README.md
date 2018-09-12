Mobility Ransack
================

Search on translated attributes with
[Mobility](https://github.com/shioyama/mobility) and
[Ransack](https://github.com/activerecord-hackery/ransack).

## Installation

Just add the gem to your Gemfile:

```ruby
gem 'mobility-ransack'
```

Now enable the `ransack` plugin in Mobility's configuration so that it can be
used, and optionally set the value for the `:ransack` key in `default_options`
to `true` to enable it for all translated attributes on all models.

```ruby
Mobility.configure do |config|
  # ...
  config.plugins += [:ransack]
  # config.default_options[:ransack] = true
end
```

If you left the `default_options` line above commented out, you will need to
explicitly enable ransack for each attribute you want to search on with the
`ransack` option, like this:

```ruby
class Post < ApplicationRecord
  extend Mobility
  translates :foo, ransack: true
end
```

You can search on `foo` with Ransack just like any untranslated attribute, with
param keys/values like `title_cont`, `title_eq`, etc.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
