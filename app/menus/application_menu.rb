# coding: utf-8
# frozen_string_literal: true

require "readline"

class ApplicationMenu
  def initialize(source: nil, printer:)
    self.out = printer
    self.source = source
    self.selected_option = []
    self.input = nil
  end

  def read
    loop do
      if options&.empty?
        out.puts no_options_message
        break
      end

      out.puts main_message(result_message)
      self.input = Readline.readline(prompt(menu_name))&.strip

      case input&.downcase
      when nil
        out.puts
        raise Back, source
      when "q"
        out.puts goodbye_message
        raise Quit
      else
        Readline::HISTORY.push(input)
        self.selected_option = make_selection
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
    :input,
    :result_message,
    :out,
    :selected_option,
    :source,
    :decorator,
    :success_message

  delegate :options,
           :options_message,
           :main_message,
           :goodbye_message,
           :valid_message,
           :no_options_message,
           :prompt,
           :prompt_options,
           :invalid_message,
           to: :decorator

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
