# frozen_string_literal: true

require "active_record"
require "yaml"

module DB
  class << self
    # Connect to the vending machine database
    def connect(environment: :development)
      config = config(environment: environment)
      ActiveRecord::Base.establish_connection(config)
    end

    # Run migrations on the currently connected vending machine database
    def migrate
      ActiveRecord::Migrator.migrate(File.join(db_dir, "migrate"))
    end

    # Drop the datbaase for the given environment
    def drop(environment: :development)
      db = config(environment: environment).fetch("database")
      File.delete(db) if File.exist?(db)
    end

    # Load the database configuration to a Hash
    def config(environment: :development)
      @config ||=
        YAML.safe_load(File.open(File.join(db_dir, "config.yml")))
          .fetch(environment.to_s)
    end

    def db_dir
      File.join(File.dirname(".."), "db")
    end
  end
end
