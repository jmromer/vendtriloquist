# frozen_string_literal: true

proj_root = File.dirname(__dir__)
db = File.join(proj_root, "db")
app = File.join(proj_root, "app")
$LOAD_PATH.unshift(File.expand_path(db))
$LOAD_PATH.unshift(File.expand_path(app))

require "database_cleaner/active_record"
require "factory_bot"
require "pry"
require "shoulda-matchers"

require "db"
require "vending_machine"

DB.drop(environment: :test) if ENV.key?("DB_TEST_RESET")
DB.connect(environment: :test)
DB.migrate

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  if config.files_to_run.one?
    config.default_formatter = "doc"
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = false
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end

# ShouldaMatchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

# FactoryBot configuration
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

# DatabaseCleaner configuration
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
