# frozen_string_literal: true

db = File.join(File.dirname(__dir__), "db")
$LOAD_PATH.unshift(File.expand_path(db))

require "utils/errors"
require "utils/printer"
require "vending_machine"

class CLI
  def start
    VendingMachine.router(printer: Printer.instance)
  rescue Quit
    exit(0)
  end
end
