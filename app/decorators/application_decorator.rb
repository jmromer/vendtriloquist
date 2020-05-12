# coding: utf-8
# frozen_string_literal: true

require "utils/color"
require "utils/currency"
require "utils/localization"

class ApplicationDecorator
  include Localization
  include Color
  include Currency

  def self.decorate(object = nil)
    return new unless object
    return object if object.is_a?(self.class)
    return new(object) unless object.respond_to?(:map)

    object.map { |obj| new(obj) }
  end

  attr_accessor :undecorated

  def initialize(undecorated = nil)
    self.undecorated = undecorated
  end

  def options(object)
    self.class
      .decorate(object)
      .map
      .with_index(1) { |obj, index| obj.options_hash_entry(index) }
      .to_h
  end

  def main_message(result_message=nil)
    [color.warning(result_message), options_message]
      .compact
      .join("\n\n")
  end

  def valid_message(selection)
    color.default "You selected: #{selection}"
  end

  def invalid_message(input)
    color.error "Invalid selection: '#{input}'. Please try again."
  end

  def goodbye_message
    color.success "Thanks, bye!"
  end

  def no_options_message
    color.error("None available.")
  end

  def prompt(menu_name)
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
end
