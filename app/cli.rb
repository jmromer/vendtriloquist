# frozen_string_literal: true

db = File.join(File.dirname(__dir__), "db")
$LOAD_PATH.unshift(File.expand_path(db))

require "db"
require "vending_machine"

require "utils/color"
require "utils/errors"

module CLI
  class << self
    def start
      DB.connect
      VendingMachine.main
      quit
    rescue Interrupt
      start
    rescue Quit
      quit
    end

    def quit
      VendingMachine.out.puts Color.success("Thanks, bye!")
      exit(0)
    end
  end
end
