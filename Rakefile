# frozen_string_literal: true

app = File.join(File.dirname(__FILE__), "app")
$LOAD_PATH.unshift(File.expand_path(app))

require "cli"

namespace :db do
  desc "Reset the development database"
  task reset: %i[drop migrate seed]

  desc "Drop the development database"
  task :drop do
    printf "Dropping the development database..."
    DB.drop
    printf "done.\n"
  end

  desc "Migrate the database"
  task :migrate do
    DB.connect
    DB.migrate
  end

  desc "Seed the database"
  task :seed do
    DB.connect
    load("db/seeds.rb")
  end
end
