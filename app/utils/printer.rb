# frozen_string_literal: true

class Printer
  attr_accessor :out
  include Singleton

  def initialize(out: STDOUT)
    self.out = out
  end

  def puts(content = nil)
    str = content.to_s.strip
    return out.puts if str.empty?

    out.puts if content.is_a?(Exception)
    out.puts("#{str}\n\n")
  end
end
