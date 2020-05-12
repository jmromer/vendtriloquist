# frozen_string_literal: true

require "decorators/main_menu_decorator"
require "menus/application_menu"
require "utils/errors"

class MainMenu < ApplicationMenu
  def initialize(source: nil, printer:)
    super
    self.decorator = MainMenuDecorator.new
  end

  protected

  def make_selection
    options[input&.downcase]
  end

  def dispatch
    raise Route, selection
  end
end
