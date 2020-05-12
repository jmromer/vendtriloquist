# coding: utf-8
# frozen_string_literal: true

require "readline"
require "utils/color"

class ApplicationMenu
  def initialize
    self.result_message = result_message
    self.out = VendingMachine.out
    self.selected_option = []
    self.input = nil
  end

  def read
    loop do
      if options&.empty?
        out.puts Color.error("None available.")
        break
      end

      out.puts main_message
      self.input = Readline.readline(prompt)&.strip

      case input
      when nil
        out.puts
        break
      when "q", "Q"
        raise Quit
      else
        Readline::HISTORY.push(input)
        self.selected_option = make_selection
      end

      if selection
        out.puts(Color.default(valid_message))
        unwind = dispatch
        break if unwind
      else
        out.puts(Color.error(invalid_message))
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
      "[#{Color.default(menu_name)}] #{Color.prompt("» ")}",
    ].join("\n")
  end

  def prompt_options
    @prompt_options ||= {
      Color.option("ctrl-d") => "back",
      Color.option("ctrl-c") => "main menu",
      Color.option("q") => "quit",
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
