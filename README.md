Mobility Ransack
================

[![Gem Version](https://badge.fury.io/rb/mobility-ransack.svg)][gem]
[![Build Status](https://github.com/shioyama/mobility-ransack/workflows/CI/badge.svg)][actions]
[![Code Climate](https://api.codeclimate.com/v1/badges/2494f02bcd6b65a545fa/maintainability.svg)][codeclimate]

[gem]: https://rubygems.org/gems/mobility-ransack
[actions]: https://github.com/shioyama/mobility-ransack/actions
[codeclimate]: https://codeclimate.com/github/shioyama/mobility-ransack

Search on translated attributes with
[Mobility](https://github.com/shioyama/mobility) and
[Ransack](https://github.com/activerecord-hackery/ransack).

## Installation

Just add the gem to your Gemfile:

```ruby
gem 'mobility-ransack', '~> 1.2.2'
```

Now enable the `ransack` plugin in Mobility's configuration:

```ruby
Mobility.configure do
  plugins do
    ransack

    # ...
  end
end
```

This will enable the ransack plugin for all models. Disable it by passing
`false` to the `ransack` option:

```ruby
class Post < ApplicationRecord
  extend Mobility
  translates :foo, ransack: false
end
```

You can search on `foo` with Ransack just like any untranslated attribute, e.g.
if `Post` has a `title` attribute translated with the Jsonb backend:

```ruby
Post.ransack(title_cont: "foo").result
#=> SELECT "posts".* FROM "posts" WHERE ("posts"."title" ->> 'en') ILIKE '%foo%'
```

Other backends work exactly the same way.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
