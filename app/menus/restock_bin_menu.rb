# frozen_string_literal: true

require "decorators/restock_bin_decorator"
require "menus/application_menu"

class RestockBinMenu < ApplicationMenu
  alias bin selection

  protected

  def options
    RestockBinDecorator.options
  end

  def options_message
    RestockBinDecorator.options_message
  end

  def menu_name
    "restock: select a bin"
  end

  def make_selection
    options[input.upcase]
  end

  def dispatch
    VendingMachine.restock_product(bin: bin)
  end
end
