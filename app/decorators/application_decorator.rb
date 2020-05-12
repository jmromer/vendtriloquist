# coding: utf-8
# frozen_string_literal: true

require "utils/localization"
require "utils/color"

class ApplicationDecorator
  include Localization
  extend Localization

  attr_accessor :obj

  def initialize(obj = nil)
    self.obj = obj
  end

  def self.decorate(object)
    return new(object) unless object.respond_to?(:map)

    object.map { |obj| new(obj) }
  end

  def options(object)
    self.class.decorate(object).map(&:options_hash_entry).to_h
  end

  def self.color
    Color
  end

  def color
    self.class.color
  end

  def self.currency
    Currency
  end

  def currency
    self.class.currency
  end

  def main_message(result_message=nil)
    [color.warning(result_message), options_message]
      .compact
      .join("\n\n")
  end

  def valid_message(selection)
    color.default \
      "You selected: #{selection}"
  end

  def invalid_message
    color.error \
      "Invalid selection: '#{input}'. Please try again."
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
