Mobility Ransack
================

[![Gem Version](https://badge.fury.io/rb/mobility-ransack.svg)][gem]
[![Build Status](https://travis-ci.org/shioyama/mobility-ransack.svg?branch=master)][travis]
[![Code Climate](https://api.codeclimate.com/v1/badges/2494f02bcd6b65a545fa/maintainability.svg)][codeclimate]

[gem]: https://rubygems.org/gems/mobility-ransack
[travis]: https://travis-ci.org/shioyama/mobility-ransack
[codeclimate]: https://codeclimate.com/github/shioyama/mobility-ransack

Search on translated attributes with
[Mobility](https://github.com/shioyama/mobility) and
[Ransack](https://github.com/activerecord-hackery/ransack).

## Installation

Just add the gem to your Gemfile:

```ruby
gem 'mobility-ransack', '~> 0.2.2'
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

You can search on `foo` with Ransack just like any untranslated attribute, e.g.
if `Post` has a `title` attribute translated with the Jsonb backend:

```ruby
Post.ransack(title_cont: "foo").result
#=> SELECT "posts".* FROM "posts" WHERE ("posts"."title" ->> 'en') ILIKE '%foo%'
```

Other backends work exactly the same way.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
