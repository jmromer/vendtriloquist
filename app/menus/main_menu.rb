# frozen_string_literal: true

require "decorators/main_menu_decorator"
require "menus/application_menu"

class MainMenu < ApplicationMenu
  protected

  def options
    MainMenuDecorator.options
  end

  def options_message
    MainMenuDecorator.options_message
  end

  def make_selection
    options[input&.downcase]
  end

  def dispatch
    VendingMachine.public_send(selection)
  end
end
