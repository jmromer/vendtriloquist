# frozen_string_literal: true

require "decorators/application_decorator"

class MainMenuDecorator < ApplicationDecorator
  def self.options
    @options ||= {
      "1" => [:purchase, "Make a purchase"],
      "2" => [:restock_select_bin, "Add inventory"],
    }.freeze
  end

  def self.options_message
    [
      color.warning("Main menu"),
      "",
      options.map { |k, (_, v)| options_entry(k, v) }.join("\n"),
    ].join("\n")
  end

  def self.options_entry(k, v)
    "(#{color.option(k)}) #{v}"
  end
end
