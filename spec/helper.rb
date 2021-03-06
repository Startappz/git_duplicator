require 'rspec'
require 'webmock/rspec'
require 'simplecov'
require 'coveralls'
require 'dotenv'

Dotenv.load File.expand_path(
  File.join(File.dirname(__FILE__), '../', '.test.env')
)

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(95.0)
end

require_relative '../lib/git_duplicator.rb'
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  # --seed 1234
  config.order = 'random'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
