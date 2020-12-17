source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in mobility-ransack.gemspec
gemspec

group :development, :test do
  gem 'rails', "~> #{ENV['RAILS_VERSION'] || '6.1'}.0"

  gem 'pry'
  gem 'pry-byebug'
end
