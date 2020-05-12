# frozen_string_literal: true

require "decorators/restock_bin_decorator"
require "menus/application_menu"
require "menus/restock_product_menu"

class RestockBinMenu < ApplicationMenu
  alias bin selection

  def decorator
    RestockBinDecorator.new
  end

  protected

  def menu_name
    "restock: select a bin"
  end

  def make_selection
    options[input.upcase]
  end

  def dispatch
    RestockProductMenu.new(bin: bin.obj, printer: out).read
  end
end
