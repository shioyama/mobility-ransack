source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in mobility-ransack.gemspec
gemspec

group :development, :test do
  gem 'rails', "~> #{ENV['RAILS_VERSION'] || '6.1'}.0"
  # Active Record 7.1 and older require sqlite3 1.x; 8.0 and later require 2.1+.
  gem 'sqlite3', (ENV['RAILS_VERSION'] || '6.1').to_f < 7.2 ? '~> 1.4' : '>= 2.1'

  gem 'pry'
  gem 'pry-byebug'
end
