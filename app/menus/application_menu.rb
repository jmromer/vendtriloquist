# coding: utf-8
# frozen_string_literal: true

require "readline"

class ApplicationMenu
  def initialize(source: nil, decorator: nil, printer:)
    self.decorator = decorator
    self.out = printer
    self.source = source
    self.selected_option = []
    self.input = nil
  end

  def read
    loop do
      raise ReturnToMain, no_options_message if options&.empty?

      out.puts main_message(result_message)
      self.input = Readline.readline(prompt(menu_name))&.strip

      case input&.downcase
      when nil then go_back
      when "q" then quit
      else process_input
      end

      if selection
        out.puts(valid_message(selection_label))
        unwind = dispatch
        break if unwind
      else
        out.puts(invalid_message(input))
        next
      end
    end
  end

  protected

  attr_accessor \
    :decorator,
    :input,
    :result_message,
    :out,
    :selected_option,
    :source,
    :decorator,
    :success_message

  delegate \
    :currency,
    :goodbye_message,
    :invalid_message,
    :main_message,
    :no_options_message,
    :options,
    :options_message,
    :prompt,
    :prompt_options,
    :valid_message,
    to: :decorator

  def process_input
    Readline::HISTORY.push(input)
    self.selected_option = make_selection
  end

  def go_back
    out.puts
    raise Back, source
  end

  def quit
    out.puts goodbye_message
    raise Quit
  end

  def selection
    selected_option&.first
  end

  def selection_label
    selected_option&.last
  end

  def menu_name
    self.class
      .to_s
      .gsub(/([a-z])([A-Z])/, '\1_\2')
      .downcase
      .chomp("_menu")
      .tr("_", " ")
  end

  def make_selection
    raise NotImplementedError
  end

  def dispatch
    raise NotImplementedError
  end
end
