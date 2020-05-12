# frozen_string_literal: true

require "logger"
require "singleton"

class Printer
  attr_accessor :out
  include Singleton

  def initialize(out: STDOUT, audit: nil, ui: nil)
    self.out = out
    self.audit = audit || Logger.new(audit_log_file)
    self.ui = ui || Logger.new(ui_log_file)
  end

  def puts(content = nil)
    str = content.to_s.strip
    return out.puts if str.empty?

    out.puts if content.is_a?(Exception)
    print_line(str)
  end

  private

  attr_accessor :audit, :ui

  def print_line(str)
    out.puts("#{str}\n\n")
    ui.info(str)
    audit.info(str.uncolorize)
  end

  def ui_log_file
    log_file("ui.log")
  end

  def audit_log_file
    log_file("audit.log")
  end

  def log_file(logname)
    path = File.join(File.expand_path("../..", __dir__), "logs", logname)
    File.open(path, File::WRONLY | File::APPEND | File::CREAT)
  end
end
