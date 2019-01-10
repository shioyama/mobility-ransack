source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in mobility-ransack.gemspec
gemspec

group :development, :test do
  if ENV['RAILS_VERSION'] == '5.1'
    gem 'rails', '>= 5.1', '< 5.2'
  elsif ENV['RAILS_VERSION'] == '5.0'
    gem 'rails', '>= 5.0', '< 5.1'
  else
    gem 'rails', '>= 5.2.0.rc2', '< 5.3'
  end

  gem 'pry'
  gem 'pry-byebug'
end
