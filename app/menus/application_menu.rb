# coding: utf-8
# frozen_string_literal: true

require "readline"
require "utils/color"

class ApplicationMenu
  def initialize(source: nil, printer:)
    self.out = printer
    self.source = source
    self.selected_option = []
    self.input = nil
  end

  def self.color
    Color
  end

  def color
    self.class.color
  end

  def read
    loop do
      if options&.empty?
        out.puts color.error("None available.")
        break
      end

      out.puts main_message
      self.input = Readline.readline(prompt)&.strip

      case input&.downcase
      when nil
        out.puts
        raise Back, source
      when "q"
        out.puts Color.success "Thanks, bye!"
        raise Quit
      else
        Readline::HISTORY.push(input)
        self.selected_option = make_selection
      end

      if selection
        out.puts(color.default(valid_message))
        unwind = dispatch
        break if unwind
      else
        out.puts(color.error(invalid_message))
        next
      end
    end
  end

  protected

  attr_accessor \
    :input,
    :result_message,
    :out,
    :selected_option,
    :source,
    :success_message

  def main_message
    [result_message, options_message]
      .compact
      .join("\n\n")
  end

  def selection
    selected_option&.first
  end

  def selection_label
    selected_option&.last
  end

  def prompt
    [
      prompt_options,
      "[#{color.default(menu_name)}] #{color.prompt("» ")}",
    ].join("\n")
  end

  def prompt_options
    @prompt_options ||= {
      color.option("ctrl-d") => "back",
      color.option("ctrl-c") => "main menu",
      color.option("q") => "quit",
    }.map { |opt, desc| "[#{opt}] #{desc}" }.join(" ")
  end

  def menu_name
    self.class
      .to_s
      .gsub(/([a-z])([A-Z])/, '\1_\2')
      .downcase
      .chomp("_menu")
      .tr("_", " ")
  end

  def valid_message
    "You selected: #{selection_label}"
  end

  def invalid_message
    "Invalid selection: '#{input}'. Please try again."
  end

  def make_selection
    raise NotImplementedError
  end

  def dispatch
    raise NotImplementedError
  end
end
