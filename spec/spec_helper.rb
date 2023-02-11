# frozen_string_literal: true

require "bundler/setup"
require "active_record"
require "mobility"
require "mobility/ransack"
require "pry"

require "database_cleaner"
DatabaseCleaner.strategy = :transaction

ENV['RAILS_VERSION'] ||= "5.2"
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    DatabaseCleaner.start
    I18n.locale = :en
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Mobility.configure do |config|
  config.plugins do
    ransack
    backend :key_value
    reader
    writer
  end
end

class MobilityRansackTest < ActiveRecord::Migration[ENV['RAILS_VERSION'].to_f]
  def self.up
    create_table :authors do
    end

    create_table :comments do |t|
      t.integer :post_id
    end

    create_table :posts do |t|
      t.integer :author_id
      t.string :tags
    end

    create_table :mobility_string_translations do |t|
      t.string  :locale
      t.string  :key
      t.string  :value
      t.integer :translatable_id
      t.string  :translatable_type
      t.timestamps
    end

    create_table :mobility_text_translations do |t|
      t.string  :locale
      t.string  :key
      t.text    :value
      t.integer :translatable_id
      t.string  :translatable_type
      t.timestamps
    end
  end
end

ActiveRecord::Migration.verbose = false
MobilityRansackTest.up

class Author < ActiveRecord::Base
  extend Mobility
  has_many :posts
  translates :website, type: :string

  def self.ransackable_attributes(auth_object = nil)
    %w[website]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[mobility_string_translations posts]
  end
end

class Post < ActiveRecord::Base
  extend Mobility
  translates :title, type: :string
  translates :content, type: :text
  belongs_to :author, optional: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title content tags]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[mobility_string_translations mobility_text_translations author]
  end
end

class Comment < ActiveRecord::Base
  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.ransackable_associations(auth_object = nil)
    %w[post]
  end
end
