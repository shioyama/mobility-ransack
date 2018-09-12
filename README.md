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

Now enable ransack for attributes on a model with the `ransack` option:

```ruby
class Post < ApplicationRecord
  extend Mobility
  translates :foo, ransack: true
end
```

Now you can search on `foo` with Ransack just like any untranslated attribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mobility::Ransack project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/shioyama/mobility-ransack/blob/master/CODE_OF_CONDUCT.md).
