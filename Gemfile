# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "activerecord", "~> 5.1.4"
gem "colorize"
gem "rake"
gem "sqlite3"

group :development, :test do
  gem "jazz_fingers", github: "plribeiro3000/jazz_fingers"
  gem "rufo"
end

group :test do
  gem "database_cleaner-active_record"
  gem "factory_bot"
  gem "rspec"
  gem "shoulda-matchers",
      github: "jmromer/shoulda-matchers",
      branch: "fix-in-nomethod"
end
