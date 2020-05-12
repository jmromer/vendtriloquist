# frozen_string_literal: true

require "colorize"

module Color
  def color
    Color
  end

  class << self
    def default(value, disabled = false)
      return disabled(value) if disabled

      value.to_s.colorize(:white)
    end

    def option(value, disabled = false)
      return disabled(value) if disabled

      value.to_s.colorize(:blue)
    end

    def prompt(value)
      value.to_s.colorize(:red)
    end

    def disabled(value)
      value.to_s.colorize(:light_black)
    end

    def error(value)
      value.to_s.colorize(:red)
    end

    def success(value)
      value.to_s.colorize(:green)
    end

    def warning(value)
      value.to_s.colorize(:yellow)
    end
  end
end
