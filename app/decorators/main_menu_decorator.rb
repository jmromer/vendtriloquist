# frozen_string_literal: true

require "decorators/application_decorator"

class MainMenuDecorator < ApplicationDecorator
  def options
    @options ||= {
      "1" => [:purchase_menu, "Make a purchase"],
      "2" => [:restock_menu, "Add inventory"],
    }.freeze
  end

  def options_message
    [
      color.warning("Main menu"),
      "",
      options.map { |k, (_, v)| options_entry(k, v) }.join("\n"),
    ].join("\n")
  end

  def options_entry(k, v)
    "(#{color.option(k)}) #{v}"
  end
end
